import 'dart:async';

import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../models/payment_model.dart';
import '../models/transaction.dart';
import '../utils/app_constants.dart';

// RazorpayService wraps the Razorpay SDK and exposes one Future-based API.
// The SDK itself works with callbacks, so we convert callbacks into a Future.
class RazorpayService {
  final Razorpay _razorpay = Razorpay();
  Completer<PaymentModel>? _paymentCompleter;
  _RazorpayRequest? _activeRequest;

  RazorpayService() {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  Future<PaymentModel> openCheckout({
    required String receiverName,
    required String upiId,
    required double amount,
    required String note,
    required String userPhone,
    required String userName,
  }) {
    if (_paymentCompleter != null && !_paymentCompleter!.isCompleted) {
      return Future.error('A payment is already in progress');
    }

    _paymentCompleter = Completer<PaymentModel>();
    _activeRequest = _RazorpayRequest(
      receiverName: receiverName,
      upiId: upiId,
      amount: amount,
      note: note,
    );

    final options = {
      'key': AppConstants.razorpayTestKey,
      // Razorpay expects amount in paise, so ₹100 becomes 10000.
      'amount': (amount * 100).round(),
      'name': AppConstants.appName,
      'description': note,
      'prefill': {
        'contact': userPhone,
        'name': userName,
      },
      'method': {
        'upi': true,
        'card': true,
        'wallet': true,
        'netbanking': true,
      },
      // In production, pass a backend-created order_id and verify signature server-side.
      'notes': {'receiverUpiId': upiId, 'receiverName': receiverName},
    };

    _razorpay.open(options);
    return _paymentCompleter!.future;
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    final request = _activeRequest;
    final transaction = TransactionModel(
      id: response.paymentId ?? 'rzp_${DateTime.now().millisecondsSinceEpoch}',
      gatewayPaymentId: response.paymentId,
      receiverName: request?.receiverName ?? 'Razorpay Merchant',
      upiId: request?.upiId ?? 'merchant@razorpay',
      amount: request?.amount ?? 0,
      dateTime: DateTime.now(),
      status: TransactionStatus.success,
      type: TransactionType.razorpay,
      note: request?.note ?? 'Razorpay payment',
    );

    _complete(
      PaymentModel(
        isSuccess: true,
        message: 'Razorpay payment successful',
        rail: PaymentRail.razorpay,
        transaction: transaction,
        rawResponse: {
          'paymentId': response.paymentId,
          'orderId': response.orderId,
          'signature': response.signature,
        },
      ),
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    final request = _activeRequest;
    final transaction = TransactionModel(
      id: 'rzp_failed_${DateTime.now().millisecondsSinceEpoch}',
      receiverName: request?.receiverName ?? 'Razorpay Merchant',
      upiId: request?.upiId ?? 'merchant@razorpay',
      amount: request?.amount ?? 0,
      dateTime: DateTime.now(),
      status: TransactionStatus.failed,
      type: TransactionType.razorpay,
      note: request?.note ?? 'Razorpay payment',
    );

    _complete(
      PaymentModel(
        isSuccess: false,
        message: response.message ?? 'Razorpay payment failed',
        rail: PaymentRail.razorpay,
        transaction: transaction,
        rawResponse: {'code': response.code, 'message': response.message},
      ),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    final request = _activeRequest;
    final transaction = TransactionModel(
      id: 'wallet_${DateTime.now().millisecondsSinceEpoch}',
      receiverName: request?.receiverName ?? 'External Wallet',
      upiId: request?.upiId ?? 'wallet@razorpay',
      amount: request?.amount ?? 0,
      dateTime: DateTime.now(),
      status: TransactionStatus.submitted,
      type: TransactionType.razorpay,
      note: 'External wallet selected: ${response.walletName}',
    );

    _complete(
      PaymentModel(
        isSuccess: false,
        message: 'External wallet selected: ${response.walletName}',
        rail: PaymentRail.razorpay,
        transaction: transaction,
        rawResponse: {'walletName': response.walletName},
      ),
    );
  }

  void _complete(PaymentModel result) {
    if (_paymentCompleter != null && !_paymentCompleter!.isCompleted) {
      _paymentCompleter!.complete(result);
    }
    _paymentCompleter = null;
    _activeRequest = null;
  }

  void dispose() {
    // Razorpay recommends clearing listeners when the owning object is disposed.
    _razorpay.clear();
  }
}

class _RazorpayRequest {
  final String receiverName;
  final String upiId;
  final double amount;
  final String note;

  const _RazorpayRequest({
    required this.receiverName,
    required this.upiId,
    required this.amount,
    required this.note,
  });
}
