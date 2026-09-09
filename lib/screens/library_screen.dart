import 'package:flutter/material.dart';
import '../models/medicine.dart';
import '../services/firebase_service.dart';
import '../widgets/medicine_card.dart';
import 'google_photo_search_screen.dart';
import 'ingredient_results_screen.dart';
import '../l10n/app_localizations.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  final _firebase = FirebaseMedicineService();

  // Tracks which item's photo-attach write is currently in flight, so only
  // that one card shows a spinner instead of the whole screen.
  final Set<String> _findingIds = {};

  /// Opens the in-app Google image search for [medicine], and if the user
  /// grabs a photo, attaches it to that medicine in Firestore. Works the
  /// same whether the item currently has no photo or already has one the
  /// user wants to replace.
  Future<void> _findPhoto(Medicine medicine, AppLocalizations l10n) async {
    if (medicine.id == null || _findingIds.contains(medicine.id)) return;

    final url = await Navigator.of(context).push<String>(
      MaterialPageRoute(
        builder: (_) => GooglePhotoSearchScreen(medicineName: medicine.name),
      ),
    );
    if (url == null || !mounted) return;

    setState(() => _findingIds.add(medicine.id!));
    try {
      await _firebase.attachPhoto(medicine.id!, url, ImageSource.web);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.photoAttached)),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.photoGrabFailed)),
      );
    } finally {
      if (mounted) setState(() => _findingIds.remove(medicine.id));
    }
  }

  void _openSameIngredient(Medicine medicine) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) =>
            IngredientResultsScreen(substanceName: medicine.substanceName),
      ),
    );
  }

  Future<void> _confirmDelete(
      BuildContext context, Medicine medicine, AppLocalizations l10n) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteConfirmTitle),
        content: Text(l10n.deleteConfirmBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.confirm),
          ),
        ],
      ),
    );

    if (confirmed == true && medicine.id != null) {
      await _firebase.delete(medicine.id!);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.deletedSuccessfully)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return StreamBuilder<List<Medicine>>(
      stream: _firebase.streamLibrary(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 12),
                Text(l10n.loadingLibrary),
              ],
            ),
          );
        }

        final items = snapshot.data ?? [];
        if (items.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(l10n.emptyLibrary, textAlign: TextAlign.center),
            ),
          );
        }

        return ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            final medicine = items[index];
            final isFinding = _findingIds.contains(medicine.id);
            return MedicineCard(
              medicine: medicine,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
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
                          onPressed: () => _findPhoto(medicine, l10n),
                        ),
                  if (medicine.substanceName.isNotEmpty)
                    IconButton(
                      icon: const Icon(Icons.science_outlined),
                      tooltip: l10n.sameIngredientTooltip,
                      onPressed: () => _openSameIngredient(medicine),
                    ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    tooltip: l10n.deleteItem,
                    onPressed: () => _confirmDelete(context, medicine, l10n),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
