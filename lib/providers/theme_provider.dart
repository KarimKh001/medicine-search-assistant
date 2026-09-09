import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Manages light/dark mode and a swappable accent color, persisted across
/// app restarts. Satisfies requirement 3: "Theme management (colors)".
class ThemeProvider extends ChangeNotifier {
  static const _modeKey = 'theme_mode';
  static const _colorKey = 'theme_seed_color';

  static const List<Color> availableColors = [
    Color(0xFF2E7D32), // green (default, matches "Team B" health/pharma vibe)
    Color(0xFF1565C0), // blue
    Color(0xFF6A1B9A), // purple
    Color(0xFFC62828), // red
    Color(0xFFEF6C00), // orange
    Color(0xFF00838F), // teal
  ];

  ThemeMode _mode = ThemeMode.system;
  Color _seedColor = availableColors.first;

  ThemeMode get mode => _mode;
  Color get seedColor => _seedColor;

  ThemeData get lightTheme => _buildTheme(Brightness.light);

  ThemeData get darkTheme => _buildTheme(Brightness.dark);

  /// Builds a theme with explicit surfaces for the app bar, bottom nav, and
  /// scaffold background, rather than leaning on Material 3's default
  /// "surface tint" behavior.
  ///
  /// Left alone, `ColorScheme.fromSeed` washes every elevated surface (app
  /// bar, cards, nav bar) with the same faint tint of the seed color, so
  /// they all read as roughly the same brightness -- which is exactly the
  /// "everything looks the same" flatness this was reported as. Giving the
  /// app bar a solid `primary` background (with `surfaceTintColor:
  /// transparent` so it can't be re-blended toward the body's tone) makes
  /// it read as a clearly distinct top-level bar in both light and dark
  /// mode, and the bottom nav gets its own elevated surface + indicator so
  /// the selected tab is unambiguous.
  ThemeData _buildTheme(Brightness brightness) {
    final colorScheme =
        ColorScheme.fromSeed(seedColor: _seedColor, brightness: brightness);

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        surfaceTintColor: Colors.transparent,
        elevation: 2,
        titleTextStyle: TextStyle(
          color: colorScheme.onPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(color: colorScheme.onPrimary),
        actionsIconTheme: IconThemeData(color: colorScheme.onPrimary),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: colorScheme.surfaceContainer,
        indicatorColor: colorScheme.primaryContainer,
        surfaceTintColor: Colors.transparent,
        elevation: 3,
        height: 64,
      ),
    );
  }

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final modeIndex = prefs.getInt(_modeKey);
    final colorValue = prefs.getInt(_colorKey);

    if (modeIndex != null && modeIndex < ThemeMode.values.length) {
      _mode = ThemeMode.values[modeIndex];
    }
    if (colorValue != null) {
      _seedColor = Color(colorValue);
    }
    notifyListeners();
  }

  Future<void> setMode(ThemeMode mode) async {
    _mode = mode;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_modeKey, mode.index);
  }

  Future<void> setSeedColor(Color color) async {
    _seedColor = color;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_colorKey, color.value);
  }
}
