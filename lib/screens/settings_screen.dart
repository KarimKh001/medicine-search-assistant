import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/locale_provider.dart';
import '../l10n/app_localizations.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final themeProvider = context.watch<ThemeProvider>();
    final localeProvider = context.watch<LocaleProvider>();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(l10n.themeSection,
            style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        SegmentedButton<ThemeMode>(
          segments: [
            ButtonSegment(
                value: ThemeMode.light,
                label: Text(l10n.lightMode),
                icon: const Icon(Icons.light_mode)),
            ButtonSegment(
                value: ThemeMode.dark,
                label: Text(l10n.darkMode),
                icon: const Icon(Icons.dark_mode)),
            ButtonSegment(
                value: ThemeMode.system,
                label: Text(l10n.systemMode),
                icon: const Icon(Icons.settings_suggest)),
          ],
          selected: {themeProvider.mode},
          onSelectionChanged: (selection) =>
              themeProvider.setMode(selection.first),
        ),
        const SizedBox(height: 16),
        Text(l10n.accentColor,
            style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 8),
        Wrap(
          spacing: 12,
          children: ThemeProvider.availableColors.map((color) {
            final isSelected = themeProvider.seedColor.value == color.value;
            return GestureDetector(
              onTap: () => themeProvider.setSeedColor(color),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: isSelected
                      ? Border.all(
                          color: Theme.of(context).colorScheme.onSurface,
                          width: 3)
                      : null,
                ),
                child: isSelected
                    ? const Icon(Icons.check, color: Colors.white, size: 18)
                    : null,
              ),
            );
          }).toList(),
        ),
        const Divider(height: 40),
        Text(l10n.languageSection,
            style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        ..._languageOptions(l10n).map((option) {
          return RadioListTile<Locale>(
            title: Text(option.label),
            value: option.locale,
            groupValue: localeProvider.locale,
            onChanged: (locale) {
              if (locale != null) localeProvider.setLocale(locale);
            },
          );
        }),
      ],
    );
  }

  List<_LanguageOption> _languageOptions(AppLocalizations l10n) => [
        _LanguageOption(const Locale('en'), l10n.languageEnglish),
        _LanguageOption(const Locale('ar'), l10n.languageArabic),
        _LanguageOption(const Locale('fr'), l10n.languageFrench),
        _LanguageOption(const Locale('de'), l10n.languageGerman),
        _LanguageOption(const Locale('tr'), l10n.languageTurkish),
      ];
}

class _LanguageOption {
  final Locale locale;
  final String label;
  _LanguageOption(this.locale, this.label);
}
