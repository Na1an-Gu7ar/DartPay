import 'package:flutter/foundation.dart';

import '../models/payment_model.dart';
import '../services/api_service.dart';

// PaymentProvider focuses only on the send-money API state.
class PaymentProvider extends ChangeNotifier {
  final ApiService _apiService;

  bool _isLoading = false;
  String? _errorMessage;
  PaymentModel? _lastPayment;

  PaymentProvider(this._apiService);

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  PaymentModel? get lastPayment => _lastPayment;

  Future<PaymentModel?> sendPayment({
    required String upiId,
    required double amount,
    required String note,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    _lastPayment = null;
    notifyListeners();

    try {
      _lastPayment = await _apiService.sendPayment(upiId: upiId, amount: amount, note: note);
      return _lastPayment;
    } on ApiException catch (error) {
      _errorMessage = error.message;
      return null;
    } catch (_) {
      _errorMessage = 'Something went wrong while sending money';
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
