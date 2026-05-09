// App-wide constants keep important values in one easy-to-edit place.
class AppConstants {
  static const appName = 'DartPay';
  static const appVersion = '2.0.0';
  static const demoBalance = 24580.50;

  // TEST MODE key only. In production, never hard-code payment secrets in Flutter.
  // Create Razorpay orders on your backend and verify payment signatures there.
  static const razorpayTestKey = 'rzp_test_1234567890abcdef';
}
