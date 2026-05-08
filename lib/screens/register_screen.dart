import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../routes/app_routes.dart';
import '../utils/snackbar_helper.dart';
import '../utils/validators.dart';
import '../widgets/app_logo.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

// Register screen introduces a longer form and saves the new user locally.
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _upiController = TextEditingController();
  final _pinController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _upiController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.register(
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      upiId: _upiController.text.trim(),
      pin: _pinController.text.trim(),
    );

    if (!mounted) return;
    if (success) {
      showAppSnackBar(context, 'Account created successfully');
      context.go(AppRoutes.dashboard);
    } else {
      showAppSnackBar(context, authProvider.errorMessage ?? 'Registration failed', isError: true);
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
                const SizedBox(height: 16),
                const AppLogo(size: 72),
                const SizedBox(height: 24),
                Text(
                  'Create account',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: _nameController,
                  label: 'Full name',
                  hint: 'Enter your name',
                  icon: Icons.person_rounded,
                  validator: (value) => Validators.requiredText(value, 'Name'),
                ),
                const SizedBox(height: 14),
                CustomTextField(
                  controller: _phoneController,
                  label: 'Mobile number',
                  hint: '9876543210',
                  icon: Icons.phone_rounded,
                  keyboardType: TextInputType.phone,
                  validator: Validators.phone,
                ),
                const SizedBox(height: 14),
                CustomTextField(
                  controller: _upiController,
                  label: 'UPI ID',
                  hint: 'yourname@bank',
                  icon: Icons.alternate_email_rounded,
                  validator: Validators.upiId,
                ),
                const SizedBox(height: 14),
                CustomTextField(
                  controller: _pinController,
                  label: 'Create PIN',
                  hint: '4 digit demo PIN',
                  icon: Icons.lock_rounded,
                  obscureText: true,
                  keyboardType: TextInputType.number,
                  validator: (value) => Validators.requiredText(value, 'PIN'),
                ),
                const SizedBox(height: 24),
                Consumer<AuthProvider>(
                  builder: (context, authProvider, child) {
                    return CustomButton(
                      label: 'Register',
                      icon: Icons.person_add_rounded,
                      isLoading: authProvider.isLoading,
                      onPressed: _register,
                    );
                  },
                ),
                const SizedBox(height: 12),
                Center(
                  child: TextButton(
                    onPressed: () => context.go(AppRoutes.login),
                    child: const Text('Already have an account? Login'),
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
