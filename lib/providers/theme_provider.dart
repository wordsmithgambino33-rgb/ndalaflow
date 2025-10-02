
import 'package:flutter/material.dart';

/// Simple ThemeProvider with required getters so other code compiles.
enum ThemeType { light, dark, system }

class ThemeProvider extends ChangeNotifier {
  ThemeType _current = ThemeType.system;

  ThemeProvider({ThemeType? defaultTheme}) {
    _current = defaultTheme ?? ThemeType.system;
  }

  // Required getters
  ThemeData get lightTheme => ThemeData.light();
  ThemeData get darkTheme => ThemeData.dark();

  ThemeMode get themeMode {
    switch (_current) {
      case ThemeType.light:
        return ThemeMode.light;
      case ThemeType.dark:
        return ThemeMode.dark;
      case ThemeType.system:
      default:
        return ThemeMode.system;
    }
  }

  bool get isDarkMode => themeMode == ThemeMode.dark;

  // Small helper to toggle between light/dark (used by UI)
  void toggleTheme() {
    if (_current == ThemeType.dark) {
      _current = ThemeType.light;
    } else {
      _current = ThemeType.dark;
    }
    notifyListeners();
  }
}