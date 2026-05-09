import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:dartpay/main.dart';
import 'package:dartpay/providers/auth_provider.dart';
import 'package:dartpay/providers/connectivity_provider.dart';
import 'package:dartpay/providers/payment_provider.dart';
import 'package:dartpay/providers/theme_provider.dart';
import 'package:dartpay/providers/transaction_provider.dart';
import 'package:dartpay/services/api_service.dart';
import 'package:dartpay/services/auth_service.dart';
import 'package:dartpay/services/connectivity_service.dart';
import 'package:dartpay/services/razorpay_service.dart';
import 'package:dartpay/services/theme_service.dart';
import 'package:dartpay/services/transaction_storage_service.dart';
import 'package:dartpay/services/upi_payment_service.dart';

void main() {
  testWidgets('dartpay starts with splash screen', (tester) async {
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
        child: const dartpayApp(),
      ),
    );

    expect(find.text('dartpay'), findsOneWidget);
    expect(find.byIcon(Icons.account_balance_wallet_rounded), findsOneWidget);
  });
}
