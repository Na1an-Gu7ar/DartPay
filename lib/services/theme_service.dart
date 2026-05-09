import 'package:shared_preferences/shared_preferences.dart';

// ThemeService shows how SharedPreferences can remember user settings.
class ThemeService {
  static const _isDarkModeKey = 'is_dark_mode';

  final SharedPreferences _preferences;

  ThemeService(this._preferences);

  bool getSavedThemeMode() {
    return _preferences.getBool(_isDarkModeKey) ?? false;
  }

  Future<void> saveThemeMode(bool isDarkMode) async {
    await _preferences.setBool(_isDarkModeKey, isDarkMode);
  }
}
