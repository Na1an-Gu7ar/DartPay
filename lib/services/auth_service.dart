import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';

// AuthService is responsible for local authentication storage.
// In a real app this would talk to a backend, but here we keep it simple.
class AuthService {
  static const _tokenKey = 'auth_token';
  static const _userKey = 'auth_user';

  final SharedPreferences _preferences;

  AuthService(this._preferences);

  Future<void> saveUser(UserModel user) async {
    await _preferences.setString(_tokenKey, user.token);
    await _preferences.setString(_userKey, jsonEncode(user.toJson()));
  }

  UserModel? getSavedUser() {
    final userText = _preferences.getString(_userKey);
    if (userText == null) return null;

    try {
      return UserModel.fromJson(jsonDecode(userText) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  bool hasToken() {
    return _preferences.getString(_tokenKey)?.isNotEmpty ?? false;
  }

  Future<void> clearUser() async {
    await _preferences.remove(_tokenKey);
    await _preferences.remove(_userKey);
  }
}
