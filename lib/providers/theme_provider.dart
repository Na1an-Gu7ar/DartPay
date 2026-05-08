import 'package:flutter/foundation.dart';

import '../services/theme_service.dart';

// ThemeProvider stores theme state and persists it using SharedPreferences.
class ThemeProvider extends ChangeNotifier {
  final ThemeService _themeService;
  bool _isDarkMode;

  ThemeProvider(this._themeService) : _isDarkMode = _themeService.getSavedThemeMode();

  bool get isDarkMode => _isDarkMode;

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
    await _themeService.saveThemeMode(_isDarkMode);
  }
}
