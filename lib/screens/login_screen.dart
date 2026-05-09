import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../routes/app_routes.dart';
import '../utils/app_constants.dart';
import '../utils/snackbar_helper.dart';
import '../utils/validators.dart';
import '../widgets/app_logo.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

// Login demonstrates form validation, Provider.of, loading states, and local storage.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController(text: '9876543210');
  final _pinController = TextEditingController(text: '1234');

  @override
  void dispose() {
    _phoneController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    // Provider.of with listen: false is useful inside event handlers.
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.login(
      phone: _phoneController.text.trim(),
      pin: _pinController.text.trim(),
    );

    if (!mounted) return;
    if (success) {
      showAppSnackBar(context, 'Welcome back to ${AppConstants.appName}');
      context.go(AppRoutes.dashboard);
    } else {
      showAppSnackBar(context, authProvider.errorMessage ?? 'Login failed', isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                const AppLogo(),
                const SizedBox(height: 28),
                Text(
                  'Login to\n${AppConstants.appName}',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 12),
                const Text('Use the demo values or enter your own details.'),
                const SizedBox(height: 32),
                CustomTextField(
                  controller: _phoneController,
                  label: 'Mobile number',
                  hint: 'Enter your mobile number',
                  icon: Icons.phone_rounded,
                  keyboardType: TextInputType.phone,
                  validator: Validators.phone,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _pinController,
                  label: 'UPI PIN',
                  hint: 'Enter at least 4 digits',
                  icon: Icons.lock_rounded,
                  obscureText: true,
                  keyboardType: TextInputType.number,
                  validator: (value) => Validators.requiredText(value, 'UPI PIN'),
                ),
                const SizedBox(height: 28),
                Consumer<AuthProvider>(
                  builder: (context, authProvider, child) {
                    return CustomButton(
                      label: 'Login',
                      icon: Icons.login_rounded,
                      isLoading: authProvider.isLoading,
                      onPressed: _login,
                    );
                  },
                ),
                const SizedBox(height: 16),
                Center(
                  child: TextButton(
                    onPressed: () => context.go(AppRoutes.register),
                    child: const Text('New to SwiftPay? Create account'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
