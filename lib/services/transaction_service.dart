import '../models/transaction.dart';

// A tiny service class for creating transaction objects.
// This is not a real payment service. It only creates sample app data.
class TransactionService {
  const TransactionService();

  // Creates a new successful transaction from the UPI ID and amount.
  TransactionModel createTransaction({
    required String upiId,
    required double amount,
    required TransactionType type
  }) {
    final now = DateTime.now();

    return TransactionModel(
      // Date milliseconds are good enough as a simple beginner-friendly id.
      id: now.millisecondsSinceEpoch.toString(),
      upiId: upiId,
      amount: amount,
      dateTime: now,
      receiverName: "shamless",
      type: type,
      status: TransactionStatus.success,
      note: "UPI Money"
    );
  }
}
