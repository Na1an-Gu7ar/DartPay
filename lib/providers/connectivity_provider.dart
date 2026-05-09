import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

import '../services/connectivity_service.dart';

// ConnectivityProvider keeps online/offline state available to payment screens.
class ConnectivityProvider extends ChangeNotifier {
  final ConnectivityService _connectivityService;
  StreamSubscription<List<ConnectivityResult>>? _subscription;
  bool _isOnline = true;

  ConnectivityProvider(this._connectivityService) {
    _checkInitialConnection();
    _subscription = _connectivityService.onConnectivityChanged.listen((results) {
      _isOnline = results.any((result) => result != ConnectivityResult.none);
      notifyListeners();
    });
  }

  bool get isOnline => _isOnline;

  Future<void> _checkInitialConnection() async {
    try {
      _isOnline = await _connectivityService.hasInternetConnection();
    } catch (_) {
      // Widget tests and unsupported platforms may not have the native plugin.
      _isOnline = true;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
