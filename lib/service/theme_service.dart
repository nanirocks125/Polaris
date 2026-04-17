import 'package:flutter/material.dart';

class ThemeService extends ChangeNotifier {
  // Default to dark mode as you requested
  ThemeMode _themeMode = ThemeMode.dark;

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  void toggleTheme(bool isDark) {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    // This line tells MaterialApp to rebuild
    notifyListeners();
  }
}

// Global instance for easy access
final themeService = ThemeService();
