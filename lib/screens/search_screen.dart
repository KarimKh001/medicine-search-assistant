import 'package:flutter/material.dart';
import '../models/medicine.dart';
import '../services/medicine_api_service.dart';
import '../services/firebase_service.dart';
import '../widgets/medicine_card.dart';
import 'add_medicine_dialog.dart';
import 'google_photo_search_screen.dart';
import 'ingredient_results_screen.dart';
import '../l10n/app_localizations.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  final _api = MedicineApiService();
  final _firebase = FirebaseMedicineService();

  List<Medicine> _results = [];

  bool _loading = false;
  bool _hasSearched = false;
  String? _error;
  SearchPhase _phase = SearchPhase.library;

  // Search filters: which openFDA field the query is matched against, and
  // an optional route-of-administration filter (openFDA's closest field to
  // "dosage form" on the drug/label endpoint -- see medicine_api_service.dart).
  SearchField _field = SearchField.all;
  String? _route;

  // Tracks which result's photo-attach write is currently in flight, so
  // only that card shows a spinner.
  final Set<String> _findingIds = {};

  /// Opens the in-app Google image search for [medicine], and if the user
  /// grabs a photo, attaches it to that (already-saved) medicine in
  /// Firestore and updates the card in place.
  Future<void> _findPhoto(Medicine medicine, int index) async {
    final l10n = AppLocalizations.of(context)!;
    final url = await Navigator.of(context).push<String>(
      MaterialPageRoute(
        builder: (_) => GooglePhotoSearchScreen(medicineName: medicine.name),
      ),
    );
    if (url == null || medicine.id == null || !mounted) return;

    setState(() => _findingIds.add(medicine.id!));
    try {
      await _firebase.attachPhoto(medicine.id!, url, ImageSource.web);
      if (!mounted) return;
      setState(() {
        _results[index] =
            medicine.copyWith(imageUrl: url, imageSource: ImageSource.web);
        _findingIds.remove(medicine.id);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.photoAttached)),
      );
    } catch (_) {
      if (!mounted) return;
      setState(() => _findingIds.remove(medicine.id));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.photoGrabFailed)),
      );
    }
  }

  /// Firestore-first search: checks the saved library before ever calling
  /// the public API (see [FirebaseMedicineService.searchAndCache]). Any
  /// API results that come back are persisted to Firestore, per
  /// requirement 1. No photo lookup happens here; results are shown with
  /// just their placeholder icon unless they already have a saved photo.
  Future<void> _search() async {
    final query = _controller.text.trim();
    if (query.isEmpty) return;

    setState(() {
      _loading = true;
      _hasSearched = true;
      _error = null;
      _results = [];
      _phase = SearchPhase.library;
    });

    try {
      final results = await _firebase.searchAndCache(
        query,
        _api,
        field: _field,
        route: _route,
        onPhaseChange: (phase) {
          if (!mounted) return;
          setState(() => _phase = phase);
        },
      );

      if (!mounted) return;
      setState(() {
        _results = results;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  /// Pushes a screen showing other medicines that share [medicine]'s active
  /// ingredient, without disturbing the current search results.
  void _openSameIngredient(Medicine medicine) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) =>
            IngredientResultsScreen(substanceName: medicine.substanceName),
      ),
    );
  }

  Future<void> _openAddManuallyDialog() async {
    final l10n = AppLocalizations.of(context)!;
    final saved = await showDialog<bool>(
      context: context,
      builder: (context) => const AddMedicineDialog(),
    );

    if (saved == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.addedManually)),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: l10n.searchHint,
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.search),
                  ),
                  onSubmitted: (_) => _search(),
                ),
              ),
              const SizedBox(width: 8),
              FilledButton(
                onPressed: _loading ? null : _search,
                child: Text(l10n.searchButton),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
          child: Row(
            children: [
              Expanded(
                child: _FilterDropdown<SearchField>(
                  label: l10n.filterSearchInLabel,
                  value: _field,
                  items: {
                    SearchField.all: l10n.filterAll,
                    SearchField.brand: l10n.filterBrandName,
                    SearchField.generic: l10n.filterGenericName,
                    SearchField.ingredient: l10n.filterIngredient,
                  },
                  onChanged: (value) {
                    setState(() => _field = value);
                    if (_hasSearched) _search();
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _FilterDropdown<String?>(
                  label: l10n.filterRouteLabel,
                  value: _route,
                  items: {
                    null: l10n.filterRouteAny,
                    for (final r in kOpenFdaRoutes) r: r,
                  },
                  onChanged: (value) {
                    setState(() => _route = value);
                    if (_hasSearched) _search();
                  },
                ),
              ),
            ],
          ),
        ),
        Expanded(child: _buildBody(l10n)),
      ],
    );
  }

  Widget _buildBody(AppLocalizations l10n) {
    if (_loading) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 12),
            Text(
              _phase == SearchPhase.library
                  ? l10n.searchingLibrary
                  : l10n.searchingApi,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.searchError, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            OutlinedButton(onPressed: _search, child: Text(l10n.retry)),
          ],
        ),
      );
    }

    if (!_hasSearched) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.search,
                  size: 40, color: Theme.of(context).colorScheme.outline),
              const SizedBox(height: 12),
              Text(l10n.searchHint, textAlign: TextAlign.center),
            ],
          ),
        ),
      );
    }

    if (_results.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l10n.noResults, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: _openAddManuallyDialog,
                icon: const Icon(Icons.add),
                label: Text(l10n.addManually),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: _results.length,
      itemBuilder: (context, index) {
        final medicine = _results[index];
        final isFinding = _findingIds.contains(medicine.id);
        // Every result shown here is already persisted in Firestore
        // (either just now, or from a previous search) -- reflect that
        // instead of offering a redundant "save" action.
        return MedicineCard(
          medicine: medicine,
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // The API never returns photos, so most fresh results land
              // here with none -- this is where requirement 2's "grab a
              // photo from a web search" flow is triggered.
              if (medicine.imageSource == ImageSource.none)
                isFinding
                    ? const Padding(
                        padding: EdgeInsets.all(8),
                        child: SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                    : IconButton(
                        icon: const Icon(Icons.image_search),
                        tooltip: l10n.findPhotoButton,
                        onPressed: () => _findPhoto(medicine, index),
                      ),
              if (medicine.substanceName.isNotEmpty &&
                  _field != SearchField.ingredient)
                IconButton(
                  icon: const Icon(Icons.science_outlined),
                  tooltip: l10n.sameIngredientTooltip,
                  onPressed: () => _openSameIngredient(medicine),
                ),
              Tooltip(
                message: l10n.savedToLibraryTooltip,
                child: Icon(
                  Icons.check_circle,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Small labeled dropdown used for the search filter row.
class _FilterDropdown<T> extends StatelessWidget {
  final String label;
  final T value;
  final Map<T, String> items;
  final ValueChanged<T> onChanged;

  const _FilterDropdown({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      items: [
        for (final entry in items.entries)
          DropdownMenuItem<T>(
            value: entry.key,
            child: Text(entry.value, overflow: TextOverflow.ellipsis),
          ),
      ],
      onChanged: (v) {
        if (v != null || items.containsKey(null)) onChanged(v as T);
      },
    );
  }
}
