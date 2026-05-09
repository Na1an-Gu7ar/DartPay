import '../models/payment_request.dart';

// Parses common UPI QR payloads like:
// upi://pay?pa=name@bank&pn=Receiver&am=100&tn=Coffee
class UpiQrParser {
  static PaymentRequest? parse(String rawValue) {
    final uri = Uri.tryParse(rawValue);
    if (uri == null || uri.scheme.toLowerCase() != 'upi') return null;

    final params = uri.queryParameters;
    final upiId = params['pa'];
    if (upiId == null || upiId.isEmpty) return null;

    return PaymentRequest(
      upiId: upiId,
      receiverName: params['pn'] ?? 'UPI Merchant',
      amount: double.tryParse(params['am'] ?? '') ?? 0,
      note: params['tn'] ?? params['tr'] ?? 'UPI QR payment',
    );
  }
}
