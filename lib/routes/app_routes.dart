import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/payment_model.dart';
import '../models/payment_request.dart';
import '../models/transaction.dart';
import '../providers/auth_provider.dart';
import '../screens/dashboard_screen.dart';
import '../screens/login_screen.dart';
import '../screens/qr_scanner_screen.dart';
import '../screens/register_screen.dart';
import '../screens/send_money_screen.dart';
import '../screens/splash_screen.dart';
import '../screens/success_screen.dart';
import '../screens/transaction_detail_screen.dart';

// AppRoutes centralizes navigation names so strings are not scattered everywhere.
class AppRoutes {
  static const splash = '/';
  static const login = '/login';
  static const register = '/register';
  static const dashboard = '/dashboard';
  static const sendMoney = '/send-money';
  static const success = '/payment-success';
  static const qrScanner = '/qr-scanner';
  static const transactionDetail = '/transaction-detail';
}

// GoRouter gives us named routes and protected-route redirects.
class AppRouter {
  static GoRouter createRouter(AuthProvider authProvider) {
    return GoRouter(
      initialLocation: AppRoutes.splash,
      refreshListenable: authProvider,
      redirect: (context, state) {
        final isLoggingIn = state.matchedLocation == AppRoutes.login ||
            state.matchedLocation == AppRoutes.register;

        if (authProvider.isCheckingAuth) return AppRoutes.splash;

        if (!authProvider.isLoggedIn) {
          return isLoggingIn ? null : AppRoutes.login;
        }

        if (isLoggingIn || state.matchedLocation == AppRoutes.splash) {
          return AppRoutes.dashboard;
        }

        return null;
      },
      routes: [
        GoRoute(
          path: AppRoutes.splash,
          name: 'splash',
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: AppRoutes.login,
          name: 'login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: AppRoutes.register,
          name: 'register',
          builder: (context, state) => const RegisterScreen(),
        ),
        GoRoute(
          path: AppRoutes.dashboard,
          name: 'dashboard',
          builder: (context, state) => const DashboardScreen(),
        ),
        GoRoute(
          path: AppRoutes.sendMoney,
          name: 'sendMoney',
          builder: (context, state) {
            return SendMoneyScreen(initialRequest: state.extra as PaymentRequest?);
          },
        ),
        GoRoute(
          path: AppRoutes.qrScanner,
          name: 'qrScanner',
          builder: (context, state) => const QrScannerScreen(),
        ),
        GoRoute(
          path: AppRoutes.success,
          name: 'success',
          builder: (context, state) {
            final payment = state.extra as PaymentModel?;
            return SuccessScreen(payment: payment);
          },
        ),
        GoRoute(
          path: AppRoutes.transactionDetail,
          name: 'transactionDetail',
          builder: (context, state) {
            final transaction = state.extra as TransactionModel?;
            return TransactionDetailScreen(transaction: transaction);
          },
        ),
      ],
      errorBuilder: (context, state) => Scaffold(
        body: Center(child: Text('Route not found: ${state.uri}')),
      ),
    );
  }
}
