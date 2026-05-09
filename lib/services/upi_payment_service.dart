import 'package:upi_pay/upi_pay.dart';

import '../models/payment_model.dart';
import '../models/transaction.dart';
import '../models/upi_app_model.dart';

// UpiPaymentService teaches UPI Intent payments.
// UPI Intent opens an installed UPI app and waits for a response from that app.
class UpiPaymentService {
  final UpiPay _upiPay = UpiPay();

  Future<List<UpiAppModel>> getInstalledUpiApps() async {
    final apps = await _upiPay.getInstalledUpiApplications();

    return apps
        .map(
          (app) => UpiAppModel(
            name: app.upiApplication.getAppName(),
            packageName: app.upiApplication.toString(),
            sdkApp: app,
          ),
        )
        .toList();
  }

  Future<PaymentModel> payWithUpiIntent({
    required UpiAppModel selectedApp,
    required String receiverUpiId,
    required String receiverName,
    required double amount,
    required String note,
  }) async {
    final transactionRef = 'SWIFTPAY${DateTime.now().millisecondsSinceEpoch}';

    try {
      // This launches the selected UPI app. The user completes/cancels payment there.
      final response = await _upiPay.initiateTransaction(
        amount: amount.toStringAsFixed(2),
        app: selectedApp.sdkApp.application,
        receiverName: receiverName,
        receiverUpiAddress: receiverUpiId,
        transactionRef: transactionRef,
        transactionNote: note,
      );

      final status = TransactionModel.statusFromString(response.status.toString());
      final transaction = TransactionModel(
        id: _safeRead(() => response.txnId) ?? transactionRef,
        gatewayPaymentId: _safeRead(() => response.txnRef) ?? transactionRef,
        receiverName: receiverName,
        upiId: receiverUpiId,
        amount: amount,
        dateTime: DateTime.now(),
        status: status,
        type: TransactionType.upiIntent,
        note: note,
      );

      return PaymentModel(
        isSuccess: status == TransactionStatus.success,
        message: _messageForStatus(status),
        rail: PaymentRail.upiIntent,
        transaction: transaction,
        rawResponse: {
          'status': response.status.toString(),
          'txnId': _safeRead(() => response.txnId),
          'txnRef': _safeRead(() => response.txnRef),
          'approvalRefNo': _safeRead(() => response.approvalRefNo),
          'responseCode': _safeRead(() => response.responseCode),
        },
      );
    } catch (error) {
      final transaction = TransactionModel(
        id: transactionRef,
        receiverName: receiverName,
        upiId: receiverUpiId,
        amount: amount,
        dateTime: DateTime.now(),
        status: TransactionStatus.failed,
        type: TransactionType.upiIntent,
        note: note,
      );

      return PaymentModel(
        isSuccess: false,
        message: 'UPI payment failed or was cancelled: $error',
        rail: PaymentRail.upiIntent,
        transaction: transaction,
      );
    }
  }

  T? _safeRead<T>(T? Function() reader) {
    try {
      return reader();
    } catch (_) {
      return null;
    }
  }

  String _messageForStatus(TransactionStatus status) {
    return switch (status) {
      TransactionStatus.success => 'UPI payment successful',
      TransactionStatus.submitted => 'UPI payment submitted. Check your bank app for final status.',
      TransactionStatus.cancelled => 'UPI payment cancelled',
      TransactionStatus.failed => 'UPI payment failed',
    };
  }
}
