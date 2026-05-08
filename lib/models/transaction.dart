// Status values are kept in one enum instead of using random strings.
enum TransactionStatus { success, failed, pending }

// This model represents one payment item in DartPay.
class TransactionModel {
  final String id;
  final String receiverName;
  final String upiId;
  final double amount;
  final DateTime dateTime;
  final TransactionStatus status;
  final String note;

  const TransactionModel({
    required this.id,
    required this.receiverName,
    required this.upiId,
    required this.amount,
    required this.dateTime,
    required this.status,
    this.note = 'UPI payment',
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'].toString(),
      receiverName: json['receiverName'] as String? ?? 'DartPay User',
      upiId: json['upiId'] as String? ?? 'user@dartpay',
      amount: (json['amount'] as num? ?? 0).toDouble(),
      dateTime: DateTime.tryParse(json['dateTime'] as String? ?? '') ??
          DateTime.now(),
      status: _statusFromString(json['status'] as String? ?? 'success'),
      note: json['note'] as String? ?? 'UPI payment',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'receiverName': receiverName,
      'upiId': upiId,
      'amount': amount,
      'dateTime': dateTime.toIso8601String(),
      'status': status.name,
      'note': note,
    };
  }

  String get formattedAmount => '₹${amount.toStringAsFixed(2)}';
  String get statusLabel => status.name[0].toUpperCase() + status.name.substring(1);

  static TransactionStatus _statusFromString(String value) {
    return TransactionStatus.values.firstWhere(
      (status) => status.name == value.toLowerCase(),
      orElse: () => TransactionStatus.success,
    );
  }
}
