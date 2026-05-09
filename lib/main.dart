import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'providers/auth_provider.dart';
import 'providers/connectivity_provider.dart';
import 'providers/payment_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/transaction_provider.dart';
import 'routes/app_routes.dart';
import 'services/api_service.dart';
import 'services/auth_service.dart';
import 'services/connectivity_service.dart';
import 'services/razorpay_service.dart';
import 'services/theme_service.dart';
import 'services/transaction_storage_service.dart';
import 'services/upi_payment_service.dart';
import 'utils/app_constants.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // SharedPreferences loads before the app starts so providers can restore saved data.
  final preferences = await SharedPreferences.getInstance();
  final apiService = ApiService();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(AuthService(preferences))..checkLoginStatus(),
        ),
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(ThemeService(preferences)),
        ),
        ChangeNotifierProvider(
          create: (_) => TransactionProvider(
            apiService,
            TransactionStorageService(preferences),
          )..fetchTransactions(),
        ),
        ChangeNotifierProvider(
          create: (_) => PaymentProvider(UpiPaymentService(), RazorpayService())
            ..loadInstalledUpiApps(),
        ),
        ChangeNotifierProvider(
          create: (_) => ConnectivityProvider(ConnectivityService()),
        ),
      ],
      child: const dartpayApp(),
    ),
  );
}

class dartpayApp extends StatelessWidget {
  const dartpayApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Consumer rebuilds MaterialApp when auth or theme state changes.
    return Consumer2<AuthProvider, ThemeProvider>(
      builder: (context, authProvider, themeProvider, child) {
        return MaterialApp.router(
          title: AppConstants.appName,
          debugShowCheckedModeBanner: false,
          themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          theme: _buildTheme(Brightness.light),
          darkTheme: _buildTheme(Brightness.dark),
          routerConfig: AppRouter.createRouter(authProvider),
        );
      },
    );
  }

  // Material 3 theme with rounded cards and fintech-style blue seed color.
  ThemeData _buildTheme(Brightness brightness) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF2563EB),
      brightness: brightness,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      cardTheme: CardThemeData(
        elevation: 0,
        color: colorScheme.surfaceContainerHighest,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
        filled: true,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
