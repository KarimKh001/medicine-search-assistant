import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/medicine.dart';
import '../l10n/app_localizations.dart';

class MedicineCard extends StatelessWidget {
  final Medicine medicine;
  final Widget? trailing;
  final VoidCallback? onTap;

  const MedicineCard({
    super.key,
    required this.medicine,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Card(
      color: theme.colorScheme.surfaceContainerHigh,
      surfaceTintColor: Colors.transparent,
      elevation: 1,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImage(theme),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      medicine.name,
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    if (medicine.manufacturer.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        '${l10n.manufacturerLabel}: ${medicine.manufacturer}',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                    if (medicine.dosageForm.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        '${l10n.dosageLabel}: ${medicine.dosageForm}',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                    const SizedBox(height: 4),
                    Text(
                      medicine.description.isEmpty
                          ? l10n.noDescriptionAvailable
                          : medicine.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall
                          ?.copyWith(fontStyle: FontStyle.italic),
                    ),
                    if (medicine.imageSource != ImageSource.none) ...[
                      const SizedBox(height: 4),
                      Chip(
                        visualDensity: VisualDensity.compact,
                        materialTapTargetSize:
                            MaterialTapTargetSize.shrinkWrap,
                        label: Text(
                          switch (medicine.imageSource) {
                            ImageSource.web => l10n.sourceWeb,
                            ImageSource.manual => l10n.sourceManual,
                            _ => l10n.sourceApi,
                          },
                          style: theme.textTheme.labelSmall,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (trailing != null) ...[
                const SizedBox(width: 8),
                trailing!,
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage(ThemeData theme) {
    const size = 64.0;
    if (medicine.imageUrl == null || medicine.imageUrl!.isEmpty) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          Icons.medication_outlined,
          color: theme.colorScheme.onSurfaceVariant,
        ),
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: CachedNetworkImage(
        imageUrl: medicine.imageUrl!,
        width: size,
        height: size,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          width: size,
          height: size,
          color: theme.colorScheme.surfaceContainerHighest,
          child: const Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          width: size,
          height: size,
          color: theme.colorScheme.surfaceContainerHighest,
          child: Icon(Icons.broken_image_outlined,
              color: theme.colorScheme.onSurfaceVariant),
        ),
      ),
    );
  }
}
