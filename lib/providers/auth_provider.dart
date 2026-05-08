import 'package:flutter/foundation.dart';

import '../models/user_model.dart';
import '../services/auth_service.dart';

// AuthProvider is a ChangeNotifier.
// When login/logout changes state, notifyListeners() rebuilds listening widgets.
class AuthProvider extends ChangeNotifier {
  final AuthService _authService;

  UserModel? _user;
  bool _isLoading = false;
  bool _isCheckingAuth = true;
  String? _errorMessage;

  AuthProvider(this._authService);

  UserModel? get user => _user;
  bool get isLoggedIn => _user != null;
  bool get isLoading => _isLoading;
  bool get isCheckingAuth => _isCheckingAuth;
  String? get errorMessage => _errorMessage;

  Future<void> checkLoginStatus() async {
    _isCheckingAuth = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 700));
    _user = _authService.hasToken() ? _authService.getSavedUser() : null;

    _isCheckingAuth = false;
    notifyListeners();
  }

  Future<bool> login({required String phone, required String pin}) async {
    _setLoading(true);

    try {
      await Future.delayed(const Duration(milliseconds: 700));
      if (pin.length < 4) {
        throw Exception('UPI PIN must be at least 4 digits');
      }

      _user = UserModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: 'DartPay Learner',
        phone: phone,
        upiId: '$phone@dartpay',
        token: 'demo-token-${DateTime.now().millisecondsSinceEpoch}',
      );
      await _authService.saveUser(_user!);
      _errorMessage = null;
      return true;
    } catch (error) {
      _errorMessage = error.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> register({
    required String name,
    required String phone,
    required String upiId,
    required String pin,
  }) async {
    _setLoading(true);

    try {
      await Future.delayed(const Duration(milliseconds: 800));
      _user = UserModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        phone: phone,
        upiId: upiId,
        token: 'demo-token-${DateTime.now().millisecondsSinceEpoch}',
      );
      await _authService.saveUser(_user!);
      _errorMessage = null;
      return true;
    } catch (_) {
      _errorMessage = 'Registration failed. Please try again.';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    await _authService.clearUser();
    _user = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
