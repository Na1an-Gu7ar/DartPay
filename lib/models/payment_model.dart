import 'transaction.dart';

// PaymentRail tells the UI which real-world payment path was used.
enum PaymentRail { upiIntent, razorpay }

// PaymentModel stores one completed callback/result from a payment SDK.
class PaymentModel {
  final bool isSuccess;
  final String message;
  final PaymentRail rail;
  final TransactionModel? transaction;
  final Map<String, dynamic>? rawResponse;

  const PaymentModel({
    required this.isSuccess,
    required this.message,
    required this.rail,
    this.transaction,
    this.rawResponse,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    final transactionJson = json['transaction'];

    return PaymentModel(
      isSuccess: json['isSuccess'] as bool? ?? false,
      message: json['message'] as String? ?? 'Payment failed',
      rail: PaymentRail.values.firstWhere(
        (rail) => rail.name == json['rail'],
        orElse: () => PaymentRail.upiIntent,
      ),
      transaction: transactionJson is Map<String, dynamic>
          ? TransactionModel.fromJson(transactionJson)
          : null,
      rawResponse: json['rawResponse'] is Map<String, dynamic>
          ? json['rawResponse'] as Map<String, dynamic>
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isSuccess': isSuccess,
      'message': message,
      'rail': rail.name,
      'transaction': transaction?.toJson(),
      'rawResponse': rawResponse,
    };
  }
}
