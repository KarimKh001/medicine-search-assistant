import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../models/medicine.dart';
import '../services/firebase_service.dart';
import 'google_photo_search_screen.dart';
import '../l10n/app_localizations.dart';

/// A form dialog letting the user hand-enter a medicine that the public API
/// couldn't find (typo, regional drug name, not in openFDA's dataset, etc).
///
/// A photo can be attached two ways, both entirely user-initiated (the app
/// never fetches one automatically):
///  - Pasting a direct image URL by hand (tagged [ImageSource.manual]).
///  - Tapping "Search photo on Google", which opens Google Images inside
///    the app and grabs whatever photo the user taps (tagged
///    [ImageSource.web]) -- see google_photo_search_screen.dart.
/// If neither is used, the medicine is still saved, just without a photo.
///
/// Returns true via Navigator.pop if the medicine was saved, so the caller
/// can show a confirmation.

/// A curated subset of the FDA's official "Route of Administration"
/// vocabulary (https://www.fda.gov/industry/structured-product-labeling-resources/route-administration)
/// -- these are the exact uppercase terms openFDA's `openfda.route` field
/// uses, so picking one here keeps manually-added medicines' dosage form
/// consistent with what API search results already show. The full FDA
/// list has 100+ highly specialized clinical routes (INTRACISTERNAL,
/// TRANSENDOCARDIAL, etc.); this is trimmed to the ones that actually
/// show up on common consumer/retail medicines.
const _dosageFormOptions = [
  'ORAL',
  'TOPICAL',
  'SUBCUTANEOUS',
  'INTRAMUSCULAR',
  'INTRAVENOUS',
  'OPHTHALMIC',
  'AURICULAR (OTIC)',
  'NASAL',
  'RESPIRATORY (INHALATION)',
  'SUBLINGUAL',
  'BUCCAL',
  'RECTAL',
  'VAGINAL',
  'TRANSDERMAL',
  'DENTAL',
  'INTRADERMAL',
  'EPIDURAL',
  'INTRATHECAL',
  'IRRIGATION',
  'NOT APPLICABLE',
];

class AddMedicineDialog extends StatefulWidget {
  const AddMedicineDialog({super.key});

  @override
  State<AddMedicineDialog> createState() => _AddMedicineDialogState();
}

class _AddMedicineDialogState extends State<AddMedicineDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _manufacturerController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _firebase = FirebaseMedicineService();

  String? _selectedDosageForm;
  bool _saving = false;
  String? _statusMessage;
  String? _previewUrl;
  Timer? _previewDebounce;

  // Distinguishes how the current image URL got into the field, so it's
  // saved with the right ImageSource: true if it was just grabbed from the
  // Google search screen, false if the user typed/pasted it by hand. Reset
  // to false the moment the user edits the field themselves.
  bool _imageFromGoogleSearch = false;
  bool _settingUrlFromSearch = false;

  @override
  void initState() {
    super.initState();
    _imageUrlController.addListener(_onImageUrlChanged);
  }

  void _onImageUrlChanged() {
    if (_settingUrlFromSearch) {
      _settingUrlFromSearch = false;
      _imageFromGoogleSearch = true;
    } else {
      _imageFromGoogleSearch = false;
    }
    _previewDebounce?.cancel();
    _previewDebounce = Timer(const Duration(milliseconds: 400), () {
      if (!mounted) return;
      setState(() => _previewUrl = _normalizeUrl(_imageUrlController.text));
    });
  }

  /// Opens the in-app Google image search for whatever name is currently
  /// typed in, and fills the Image URL field (and preview) with whatever
  /// photo the user grabs.
  Future<void> _searchPhotoOnGoogle() async {
    final l10n = AppLocalizations.of(context)!;
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.nameRequiredError)),
      );
      return;
    }

    final url = await Navigator.of(context).push<String>(
      MaterialPageRoute(
        builder: (_) => GooglePhotoSearchScreen(medicineName: name),
      ),
    );
    if (url == null || !mounted) return;

    _settingUrlFromSearch = true;
    _imageUrlController.text = url;
  }

  /// Users often paste a URL without a scheme (`example.com/x.jpg`), which
  /// the underlying HTTP client can't resolve -- assume https in that case
  /// rather than silently failing. Returns null for anything blank.
  String? _normalizeUrl(String raw) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) return null;
    return trimmed.contains('://') ? trimmed : 'https://$trimmed';
  }

  @override
  void dispose() {
    _previewDebounce?.cancel();
    _imageUrlController.removeListener(_onImageUrlChanged);
    _nameController.dispose();
    _manufacturerController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _saving = true;
      _statusMessage = null;
    });

    final name = _nameController.text.trim();
    final apiSourceId = 'manual_${DateTime.now().millisecondsSinceEpoch}';

    String? imageUrl;
    ImageSource imageSourceTag = ImageSource.none;

    // A pasted image URL is a plain string, so it has no network step to
    // fail -- if the user left it blank, the medicine is just saved
    // without a photo. Normalized the same way as the live preview, so
    // what gets saved is exactly what the user saw work. Tag it [web] if
    // it came from the Google grab flow, [manual] if the user typed it.
    final normalizedUrl = _normalizeUrl(_imageUrlController.text);
    if (normalizedUrl != null) {
      imageUrl = normalizedUrl;
      imageSourceTag =
          _imageFromGoogleSearch ? ImageSource.web : ImageSource.manual;
    }

    final medicine = Medicine(
      name: name,
      manufacturer: _manufacturerController.text.trim(),
      dosageForm: _selectedDosageForm ?? '',
      description: _descriptionController.text.trim(),
      imageUrl: imageUrl,
      imageSource: imageSourceTag,
      apiSourceId: apiSourceId,
    );

    try {
      // saveIfNew internally times out every Firestore step it takes (see
      // firebase_service.dart), so this can never hang forever even if
      // it's not caught below -- this outer timeout is just a final
      // safety net.
      final saved =
          await _firebase.saveIfNew(medicine).timeout(const Duration(seconds: 30));

      if (!mounted) return;

      if (saved == null) {
        setState(() {
          _saving = false;
          _statusMessage = l10n.alreadyInLibrary;
        });
        return;
      }

      Navigator.of(context).pop(true);
    } on TimeoutException {
      if (!mounted) return;
      setState(() {
        _saving = false;
        _statusMessage = l10n.uploadTimedOut;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _saving = false;
        _statusMessage = l10n.saveFailed;
      });
    }
  }

  Widget _buildUrlPreview(ThemeData theme) {
    const size = 64.0;
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: CachedNetworkImage(
            // Bust the cache per keystroke-batch so a fixed but previously
            // broken URL doesn't keep showing the old failed state.
            key: ValueKey(_previewUrl),
            imageUrl: _previewUrl!,
            width: size,
            height: size,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              width: size,
              height: size,
              color: theme.colorScheme.surfaceContainerHighest,
              child: const Center(
                child: SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            ),
            errorWidget: (context, url, error) => Container(
              width: size,
              height: size,
              color: theme.colorScheme.errorContainer,
              child: Icon(Icons.broken_image_outlined,
                  color: theme.colorScheme.onErrorContainer),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            AppLocalizations.of(context)!.imagePreviewHint,
            style: theme.textTheme.bodySmall,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return AlertDialog(
      title: Text(l10n.addMedicineTitle),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.addMedicineSubtitle,
                style: theme.textTheme.bodySmall,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                autofocus: true,
                decoration: InputDecoration(labelText: l10n.nameFieldLabel),
                validator: (value) => (value == null || value.trim().isEmpty)
                    ? l10n.nameRequiredError
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _manufacturerController,
                decoration:
                    InputDecoration(labelText: l10n.manufacturerFieldLabel),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _selectedDosageForm,
                decoration: InputDecoration(labelText: l10n.dosageFieldLabel),
                items: _dosageFormOptions
                    .map((form) => DropdownMenuItem(
                          value: form,
                          child: Text(form),
                        ))
                    .toList(),
                onChanged: _saving
                    ? null
                    : (value) => setState(() => _selectedDosageForm = value),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descriptionController,
                decoration:
                    InputDecoration(labelText: l10n.descriptionFieldLabel),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              Text(l10n.photoFieldLabel, style: theme.textTheme.labelLarge),
              const SizedBox(height: 8),
              TextFormField(
                controller: _imageUrlController,
                decoration:
                    InputDecoration(labelText: l10n.imageUrlFieldLabel),
                keyboardType: TextInputType.url,
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: _saving ? null : _searchPhotoOnGoogle,
                icon: const Icon(Icons.image_search),
                label: Text(l10n.searchPhotoOnGoogle),
              ),
              if (_previewUrl != null) ...[
                const SizedBox(height: 8),
                _buildUrlPreview(theme),
              ],
              if (_statusMessage != null) ...[
                const SizedBox(height: 12),
                Text(
                  _statusMessage!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.of(context).pop(false),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: _saving ? null : _submit,
          child: _saving
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(l10n.addButton),
        ),
      ],
    );
  }
}
