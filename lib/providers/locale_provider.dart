import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Manages the active app language, persisted across restarts.
/// Satisfies requirement 4: "Multi-language support
/// (Arabic-English-French-Deutsch-Turkish) without content, only labels
/// and messages." -- this only ever swaps UI copy (see lib/l10n/*.arb);
/// medicine data fetched from the API/web is never translated.
class LocaleProvider extends ChangeNotifier {
  static const _localeKey = 'app_locale';

  static const List<Locale> supportedLocales = [
    Locale('en'), // English
    Locale('ar'), // Arabic
    Locale('fr'), // French
    Locale('de'), // Deutsch / German
    Locale('tr'), // Turkish
  ];

  Locale _locale = const Locale('en');
  Locale get locale => _locale;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_localeKey);
    if (code != null &&
        supportedLocales.any((l) => l.languageCode == code)) {
      _locale = Locale(code);
      notifyListeners();
    }
  }

  Future<void> setLocale(Locale locale) async {
    if (!supportedLocales.contains(locale)) return;
    _locale = locale;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, locale.languageCode);
  }
}
