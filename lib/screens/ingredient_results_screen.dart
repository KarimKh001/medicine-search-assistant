import 'package:flutter/material.dart';
import '../models/medicine.dart';
import '../services/medicine_api_service.dart';
import '../services/firebase_service.dart';
import '../widgets/medicine_card.dart';
import 'google_photo_search_screen.dart';
import '../l10n/app_localizations.dart';

/// Pushed from a result card's "same ingredient" action. Runs a fresh,
/// ingredient-scoped search (library-first, then openFDA, same as the main
/// search flow) for [substanceName] and shows every medicine that shares
/// it -- without touching or losing whatever search the user came from.
class IngredientResultsScreen extends StatefulWidget {
  final String substanceName;

  const IngredientResultsScreen({super.key, required this.substanceName});

  @override
  State<IngredientResultsScreen> createState() =>
      _IngredientResultsScreenState();
}

class _IngredientResultsScreenState extends State<IngredientResultsScreen> {
  final _api = MedicineApiService();
  final _firebase = FirebaseMedicineService();

  List<Medicine> _results = [];
  bool _loading = true;
  String? _error;
  final Set<String> _findingIds = {};

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final results = await _firebase.searchAndCache(
        widget.substanceName,
        _api,
        field: SearchField.ingredient,
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

  Future<void> _findPhoto(Medicine medicine, int index, AppLocalizations l10n) async {
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.sameIngredientScreenTitle),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '${l10n.sameIngredientSubtitlePrefix} ${widget.substanceName}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ),
          Expanded(child: _buildBody(l10n)),
        ],
      ),
    );
  }

  Widget _buildBody(AppLocalizations l10n) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.searchError, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            OutlinedButton(onPressed: _load, child: Text(l10n.retry)),
          ],
        ),
      );
    }

    if (_results.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(l10n.noResults, textAlign: TextAlign.center),
        ),
      );
    }

    return ListView.builder(
      itemCount: _results.length,
      itemBuilder: (context, index) {
        final medicine = _results[index];
        final isFinding = _findingIds.contains(medicine.id);
        return MedicineCard(
          medicine: medicine,
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
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
                        onPressed: () => _findPhoto(medicine, index, l10n),
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
