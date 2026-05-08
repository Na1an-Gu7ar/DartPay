import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:dartpay/main.dart';
import 'package:dartpay/providers/auth_provider.dart';
import 'package:dartpay/providers/payment_provider.dart';
import 'package:dartpay/providers/theme_provider.dart';
import 'package:dartpay/providers/transaction_provider.dart';
import 'package:dartpay/services/api_service.dart';
import 'package:dartpay/services/auth_service.dart';
import 'package:dartpay/services/theme_service.dart';

void main() {
  testWidgets('DartPay starts with splash screen', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    final apiService = ApiService();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthProvider(AuthService(preferences))),
          ChangeNotifierProvider(create: (_) => ThemeProvider(ThemeService(preferences))),
          ChangeNotifierProvider(create: (_) => TransactionProvider(apiService)),
          ChangeNotifierProvider(create: (_) => PaymentProvider(apiService)),
        ],
        child: const DartPayApp(),
      ),
    );

    expect(find.text('DartPay'), findsOneWidget);
    expect(find.byIcon(Icons.account_balance_wallet_rounded), findsOneWidget);
  });
}
