import 'package:flutter/material.dart';

import 'models/transaction.dart';
import 'screens/dashboard_screen.dart';
import 'screens/login_screen.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const DartPayApp());
}

// DartPayApp is the root widget of the app.
// It stores only app-wide state: theme mode and transaction history.
class DartPayApp extends StatefulWidget {
  const DartPayApp({super.key});

  @override
  State<DartPayApp> createState() => _DartPayAppState();
}

class _DartPayAppState extends State<DartPayApp> {
  // setState is used here because this project is intentionally beginner-friendly.
  bool _isDarkMode = false;
  final List<TransactionModel> _transactions = [];

  // This method is passed to screens that need to toggle the theme.
  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  // This method is passed to the send money screen through the dashboard.
  void _addTransaction(TransactionModel transaction) {
    setState(() {
      _transactions.insert(0, transaction);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DartPay',
      debugShowCheckedModeBanner: false,
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: _buildTheme(Brightness.light),
      darkTheme: _buildTheme(Brightness.dark),
      initialRoute: SplashScreen.routeName,
      routes: {
        SplashScreen.routeName: (context) => const SplashScreen(),
        LoginScreen.routeName: (context) => const LoginScreen(),
        DashboardScreen.routeName: (context) => DashboardScreen(
              isDarkMode: _isDarkMode,
              transactions: _transactions,
              onThemeToggle: _toggleTheme,
              onTransactionCreated: _addTransaction,
            ),
      },
    );
  }

  // A shared Material 3 theme keeps the UI modern with very little code.
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
