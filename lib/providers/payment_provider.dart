import 'package:flutter/foundation.dart';

import '../models/payment_model.dart';
import '../models/upi_app_model.dart';
import '../services/razorpay_service.dart';
import '../services/upi_payment_service.dart';

// PaymentProvider coordinates real payment SDK calls and exposes loading/error state.
class PaymentProvider extends ChangeNotifier {
  final UpiPaymentService _upiPaymentService;
  final RazorpayService _razorpayService;

  List<UpiAppModel> _upiApps = [];
  bool _isLoading = false;
  bool _isFetchingUpiApps = false;
  String? _errorMessage;
  PaymentModel? _lastPayment;

  PaymentProvider(this._upiPaymentService, this._razorpayService);

  List<UpiAppModel> get upiApps => _upiApps;
  bool get isLoading => _isLoading;
  bool get isFetchingUpiApps => _isFetchingUpiApps;
  String? get errorMessage => _errorMessage;
  PaymentModel? get lastPayment => _lastPayment;

  Future<void> loadInstalledUpiApps() async {
    _isFetchingUpiApps = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _upiApps = await _upiPaymentService.getInstalledUpiApps();
    } catch (_) {
      _errorMessage = 'Could not detect installed UPI apps';
    } finally {
      _isFetchingUpiApps = false;
      notifyListeners();
    }
  }

  Future<PaymentModel?> payWithUpiIntent({
    required UpiAppModel selectedApp,
    required String upiId,
    required String receiverName,
    required double amount,
    required String note,
  }) async {
    if (_isLoading) return null; // Prevent duplicate payment clicks.
    _setLoading(true);

    try {
      _lastPayment = await _upiPaymentService.payWithUpiIntent(
        selectedApp: selectedApp,
        receiverUpiId: upiId,
        receiverName: receiverName,
        amount: amount,
        note: note,
      );
      return _lastPayment;
    } catch (_) {
      _errorMessage = 'UPI payment could not be started';
      return null;
    } finally {
      _setLoading(false);
    }
  }

  Future<PaymentModel?> payWithRazorpay({
    required String upiId,
    required String receiverName,
    required double amount,
    required String note,
    required String userPhone,
    required String userName,
  }) async {
    if (_isLoading) return null;
    _setLoading(true);

    try {
      _lastPayment = await _razorpayService.openCheckout(
        receiverName: receiverName,
        upiId: upiId,
        amount: amount,
        note: note,
        userPhone: userPhone,
        userName: userName,
      );
      return _lastPayment;
    } catch (error) {
      _errorMessage = error.toString();
      return null;
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    if (value) _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _razorpayService.dispose();
    super.dispose();
  }
}
