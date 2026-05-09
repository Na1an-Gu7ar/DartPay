// PaymentRequest moves form data between QR scanner, send screen, and services.
class PaymentRequest {
  final String upiId;
  final String receiverName;
  final double amount;
  final String note;

  const PaymentRequest({
    required this.upiId,
    required this.receiverName,
    required this.amount,
    required this.note,
  });

  Map<String, String> toQueryParameters() {
    return {
      'upiId': upiId,
      'receiverName': receiverName,
      'amount': amount.toString(),
      'note': note,
    };
  }
}
