// TransactionStatus matches common payment states returned by UPI/Razorpay flows.
enum TransactionStatus { success, failed, submitted, cancelled }

enum TransactionType { upiIntent, razorpay }

// This model represents one persisted payment receipt in dartpay.
class TransactionModel {
  final String id;
  final String receiverName;
  final String upiId;
  final double amount;
  final DateTime dateTime;
  final TransactionStatus status;
  final TransactionType type;
  final String note;
  final String? gatewayPaymentId;

  const TransactionModel({
    required this.id,
    required this.receiverName,
    required this.upiId,
    required this.amount,
    required this.dateTime,
    required this.status,
    required this.type,
    this.note = 'UPI payment',
    this.gatewayPaymentId,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'].toString(),
      receiverName: json['receiverName'] as String? ?? 'dartpay User',
      upiId: json['upiId'] as String? ?? 'user@dartpay',
      amount: (json['amount'] as num? ?? 0).toDouble(),
      dateTime: DateTime.tryParse(json['dateTime'] as String? ?? '') ??
          DateTime.now(),
      status: statusFromString(json['status'] as String? ?? 'failed'),
      type: TransactionType.values.firstWhere(
        (type) => type.name == json['type'],
        orElse: () => TransactionType.upiIntent,
      ),
      note: json['note'] as String? ?? 'UPI payment',
      gatewayPaymentId: json['gatewayPaymentId'] as String?,
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
      'type': type.name,
      'note': note,
      'gatewayPaymentId': gatewayPaymentId,
    };
  }

  String get formattedAmount => '₹${amount.toStringAsFixed(2)}';
  String get statusLabel => status.name[0].toUpperCase() + status.name.substring(1);
  String get typeLabel => type == TransactionType.upiIntent ? 'UPI Intent' : 'Razorpay';

  TransactionModel copyWith({TransactionStatus? status}) {
    return TransactionModel(
      id: id,
      receiverName: receiverName,
      upiId: upiId,
      amount: amount,
      dateTime: dateTime,
      status: status ?? this.status,
      type: type,
      note: note,
      gatewayPaymentId: gatewayPaymentId,
    );
  }

  static TransactionStatus statusFromString(String value) {
    final normalized = value.toLowerCase();
    if (normalized.contains('success')) return TransactionStatus.success;
    if (normalized.contains('submit') || normalized.contains('pending')) {
      return TransactionStatus.submitted;
    }
    if (normalized.contains('cancel')) return TransactionStatus.cancelled;
    return TransactionStatus.failed;
  }
}
