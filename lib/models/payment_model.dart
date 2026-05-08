import 'transaction.dart';

// PaymentModel stores the result returned by the fake payment API.
class PaymentModel {
  final bool isSuccess;
  final String message;
  final TransactionModel? transaction;

  const PaymentModel({
    required this.isSuccess,
    required this.message,
    this.transaction,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    final transactionJson = json['transaction'];

    return PaymentModel(
      isSuccess: json['isSuccess'] as bool? ?? false,
      message: json['message'] as String? ?? 'Payment failed',
      transaction: transactionJson is Map<String, dynamic>
          ? TransactionModel.fromJson(transactionJson)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isSuccess': isSuccess,
      'message': message,
      'transaction': transaction?.toJson(),
    };
  }
}
