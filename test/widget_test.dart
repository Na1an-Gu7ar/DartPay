import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:swiftpay/main.dart';
import 'package:swiftpay/providers/auth_provider.dart';
import 'package:swiftpay/providers/connectivity_provider.dart';
import 'package:swiftpay/providers/payment_provider.dart';
import 'package:swiftpay/providers/theme_provider.dart';
import 'package:swiftpay/providers/transaction_provider.dart';
import 'package:swiftpay/services/api_service.dart';
import 'package:swiftpay/services/auth_service.dart';
import 'package:swiftpay/services/connectivity_service.dart';
import 'package:swiftpay/services/razorpay_service.dart';
import 'package:swiftpay/services/theme_service.dart';
import 'package:swiftpay/services/transaction_storage_service.dart';
import 'package:swiftpay/services/upi_payment_service.dart';

void main() {
  testWidgets('SwiftPay starts with splash screen', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    final apiService = ApiService();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthProvider(AuthService(preferences))),
          ChangeNotifierProvider(create: (_) => ThemeProvider(ThemeService(preferences))),
          ChangeNotifierProvider(
            create: (_) => TransactionProvider(apiService, TransactionStorageService(preferences)),
          ),
          ChangeNotifierProvider(
            create: (_) => PaymentProvider(UpiPaymentService(), RazorpayService()),
          ),
          ChangeNotifierProvider(create: (_) => ConnectivityProvider(ConnectivityService())),
        ],
        child: const SwiftPayApp(),
      ),
    );

    expect(find.text('SwiftPay'), findsOneWidget);
    expect(find.byIcon(Icons.account_balance_wallet_rounded), findsOneWidget);
  });
}
