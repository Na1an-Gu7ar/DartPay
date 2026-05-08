import 'package:flutter/material.dart';

import '../widgets/app_logo.dart';
import '../widgets/primary_button.dart';
import 'dashboard_screen.dart';

// This screen is UI-only. It does not connect to real authentication.
class LoginScreen extends StatefulWidget {
  static const routeName = '/login';

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();

  @override
  void dispose() {
    // Always dispose controllers created inside a StatefulWidget.
    _phoneController.dispose();
    super.dispose();
  }

  void _login() {
    // For learning purposes, the app simply navigates to the dashboard.
    Navigator.pushReplacementNamed(context, DashboardScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 36),
              const AppLogo(),
              const SizedBox(height: 28),
              Text(
                'Welcome to\nDartPay',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 12),
              Text(
                'Send money using a clean beginner-friendly Flutter UI.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 36),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Mobile number',
                  hintText: 'Enter your mobile number',
                  prefixIcon: Icon(Icons.phone_rounded),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'UPI PIN',
                  hintText: 'Enter any 4 digits',
                  prefixIcon: Icon(Icons.lock_rounded),
                ),
              ),
              const SizedBox(height: 28),
              PrimaryButton(
                label: 'Login',
                icon: Icons.login_rounded,
                onPressed: _login,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
