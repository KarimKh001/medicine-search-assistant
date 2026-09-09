import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/medicine.dart';
import 'medicine_api_service.dart';

export 'medicine_api_service.dart' show SearchField, kOpenFdaRoutes;

/// Every Firestore call below is wrapped in this timeout. Firestore's SDK
/// has no default timeout of its own -- on a flaky connection a query or
/// write can sit "in flight" indefinitely, which is what caused the
/// never-ending spinner when adding a medicine. Capping every await at 20s
/// guarantees the UI always gets either a result or an exception to show.
const _firestoreTimeout = Duration(seconds: 20);

/// Which stage a [FirebaseMedicineService.searchAndCache] call is
/// currently in, so the UI can show accurate progress text instead of a
/// generic "searching..." that doesn't match what's actually happening.
enum SearchPhase { library, api }

/// Handles all Firestore reads/writes for medicines, plus the "does this
/// medicine already exist?" check that requirement 2 depends on:
///
///   "grab a photo, and add it to the app library IF THE MEDICINE DOES NOT
///    EXIST, and add it to Firebase"
///
/// Per the supervisor's clarification, the photo itself is never fetched
/// automatically -- it's only ever attached because the user grabbed it
/// from a Google image search opened inside the app (or pasted a URL by
/// hand), then confirmed it via [attachPhoto] / the "Add manually" flow.
class FirebaseMedicineService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _db.collection('medicines');

  /// Live stream of everything currently saved in the library, newest first.
  Stream<List<Medicine>> streamLibrary() {
    return _collection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map(Medicine.fromFirestore).toList());
  }

  /// True if a medicine with this name is already saved.
  Future<bool> existsByName(String name) async {
    final snap = await _collection
        .where('nameLower', isEqualTo: name.toLowerCase())
        .limit(1)
        .get()
        .timeout(_firestoreTimeout);
    return snap.docs.isNotEmpty;
  }

  /// The full saved document for a name, if one exists (null otherwise).
  Future<Medicine?> findByName(String name) async {
    final snap = await _collection
        .where('nameLower', isEqualTo: name.toLowerCase())
        .limit(1)
        .get()
        .timeout(_firestoreTimeout);
    if (snap.docs.isEmpty) return null;
    return Medicine.fromFirestore(snap.docs.first);
  }

  /// Searches only what's already saved (manually-added medicines included),
  /// matching a case-insensitive substring of the name.
  ///
  /// Firestore has no native "contains" query -- only exact match or
  /// prefix ranges -- so this fetches the full collection once and filters
  /// client-side. That's the right tradeoff for a personal medicine
  /// library (small, bounded collection); it wouldn't scale to a huge
  /// shared dataset, but there's no realistic scenario here where that
  /// matters.
  ///
  /// [field] scopes which stored text field the query is matched against
  /// (name for brand/generic -- the model doesn't distinguish the two --
  /// or substanceName for ingredient). [route] additionally requires the
  /// stored dosageForm (openFDA route) to match, case-insensitively.
  Future<List<Medicine>> searchLibrary(
    String query, {
    SearchField field = SearchField.all,
    String? route,
  }) async {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return [];

    final trimmedRoute = route?.trim().toLowerCase() ?? '';

    final snap = await _collection.get().timeout(_firestoreTimeout);
    return snap.docs.map(Medicine.fromFirestore).where((m) {
      final matchesText = switch (field) {
        SearchField.ingredient => m.substanceName.toLowerCase().contains(q),
        SearchField.brand ||
        SearchField.generic =>
          m.name.toLowerCase().contains(q),
        SearchField.all => m.name.toLowerCase().contains(q) ||
            m.substanceName.toLowerCase().contains(q),
      };
      final matchesRoute =
          trimmedRoute.isEmpty || m.dosageForm.toLowerCase() == trimmedRoute;
      return matchesText && matchesRoute;
    }).toList();
  }

  /// Firestore-first, API-always search. Firestore is checked first purely
  /// so the UI can show what's already saved instantly and so a
  /// manually-added medicine (one openFDA doesn't have) always shows up --
  /// but having *some* cached hits does not mean the cache is complete, so
  /// the API is always queried too and the two result sets are merged.
  ///
  /// The previous version returned early whenever `cached.isNotEmpty`,
  /// which was wrong: e.g. search "Advil" (brand) -> saved to Firestore ->
  /// later search the ingredient "ibuprofen" -> the library already
  /// contains one medicine with that substance (Advil), so `cached` was
  /// non-empty and the API call was skipped entirely, hiding every other
  /// ibuprofen-based medicine that only openFDA knows about. The fix is to
  /// always hit the API as well and merge, deduping by name so nothing
  /// shows twice.
  ///
  ///  1. Search Firestore for anything already saved matching [query].
  ///  2. Always also query the public API for [query].
  ///  3. Merge by name (case-insensitive): a cached/library entry for a
  ///     name wins (it already carries a photo/id); any API result whose
  ///     name isn't already covered gets persisted (or reused if a
  ///     Firestore doc for that exact name already exists) and added.
  ///
  /// If the API call fails (e.g. offline) but there were already cached
  /// results, those are still returned instead of the whole search
  /// failing.
  Future<List<Medicine>> searchAndCache(
    String query,
    MedicineApiService api, {
    void Function(SearchPhase phase)? onPhaseChange,
    SearchField field = SearchField.all,
    String? route,
  }) async {
    onPhaseChange?.call(SearchPhase.library);
    final cached = await searchLibrary(query, field: field, route: route);

    onPhaseChange?.call(SearchPhase.api);
    List<Medicine> apiResults;
    try {
      apiResults = await api.search(query, field: field, route: route);
    } catch (e) {
      if (cached.isNotEmpty) return cached;
      rethrow;
    }

    final Map<String, Medicine> byName = {
      for (final m in cached) m.name.toLowerCase(): m,
    };

    for (final result in apiResults) {
      final key = result.name.toLowerCase();
      if (byName.containsKey(key)) continue;

      final existing = await findByName(result.name);
      if (existing != null) {
        byName[key] = existing;
        continue;
      }

      final docRef = await _collection
          .add(result.toFirestore())
          .timeout(_firestoreTimeout);
      byName[key] =
          result.copyWith(id: docRef.id, createdAt: DateTime.now());
    }

    return byName.values.toList();
  }

  /// Full save flow for a medicine added by hand (the "Add manually"
  /// dialog, used when the public API doesn't have a match):
  ///  1. Skip if it already exists in Firebase.
  ///  2. Write the medicine (with whatever photo the user picked, if any)
  ///     to Firestore.
  ///
  /// No automatic web photo lookup happens here -- the app no longer
  /// searches the web for a photo on the user's behalf; the medicine is
  /// saved with exactly the photo picked (or none).
  ///
  /// Returns the saved [Medicine] (with its new Firestore id), or null if
  /// it was already in the library.
  Future<Medicine?> saveIfNew(Medicine medicine) async {
    final alreadyExists = await existsByName(medicine.name);
    if (alreadyExists) return null;

    final docRef =
        await _collection.add(medicine.toFirestore()).timeout(_firestoreTimeout);
    return medicine.copyWith(id: docRef.id, createdAt: DateTime.now());
  }

  Future<void> delete(String id) =>
      _collection.doc(id).delete().timeout(_firestoreTimeout);

  /// Attaches a photo the user picked themselves to an already-saved
  /// medicine -- the URL grabbed from the in-app Google image search
  /// browser (see google_photo_search_screen.dart), used from both
  /// search_screen.dart and library_screen.dart.
  ///
  /// The app never looks up a photo on its own; this is always the result
  /// of an explicit user action, per requirement 2.
  Future<void> attachPhoto(
    String medicineId,
    String imageUrl,
    ImageSource source,
  ) async {
    await _collection
        .doc(medicineId)
        .update({'imageUrl': imageUrl, 'imageSource': source.name})
        .timeout(_firestoreTimeout);
  }
}
