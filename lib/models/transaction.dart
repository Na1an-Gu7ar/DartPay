// This model represents one money transfer in SwiftPay.
// Keeping models small makes beginner Flutter projects easier to understand.
class TransactionModel {
  // A simple unique text id for display and list keys.
  final String id;

  // The UPI ID where the user sent money.
  final String upiId;

  // The amount sent by the user.
  final double amount;

  // The date and time when the transaction was created.
  final DateTime dateTime;

  // A small status label shown in the UI.
  final String status;

  const TransactionModel({
    required this.id,
    required this.upiId,
    required this.amount,
    required this.dateTime,
    this.status = 'Success',
  });

  // This helper keeps currency formatting simple for beginners.
  String get formattedAmount => '₹${amount.toStringAsFixed(2)}';
}
