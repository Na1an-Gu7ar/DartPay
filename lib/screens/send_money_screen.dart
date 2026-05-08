import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../providers/payment_provider.dart';
import '../providers/transaction_provider.dart';
import '../routes/app_routes.dart';
import '../utils/snackbar_helper.dart';
import '../utils/validators.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

// SendMoneyScreen demonstrates async POST API flow through PaymentProvider.
class SendMoneyScreen extends StatefulWidget {
  const SendMoneyScreen({super.key});

  @override
  State<SendMoneyScreen> createState() => _SendMoneyScreenState();
}

class _SendMoneyScreenState extends State<SendMoneyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _upiController = TextEditingController();
  final _amountController = TextEditingController();

  @override
  void dispose() {
    _upiController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _sendMoney() async {
    if (!_formKey.currentState!.validate()) return;

    final paymentProvider = context.read<PaymentProvider>();
    final transactionProvider = context.read<TransactionProvider>();
    final payment = await paymentProvider.sendPayment(
      upiId: _upiController.text.trim(),
      amount: double.parse(_amountController.text.trim()),
    );

    if (!mounted) return;
    if (payment == null) {
      showAppSnackBar(context, paymentProvider.errorMessage ?? 'Payment failed', isError: true);
      return;
    }

    if (payment.transaction != null) {
      transactionProvider.addTransaction(payment.transaction!);
    }

    _upiController.clear();
    _amountController.clear();
    context.push(AppRoutes.success, extra: payment);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Send money')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Transfer with UPI',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text('This screen calls a fake POST API and handles loading/errors.'),
              const SizedBox(height: 24),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      CustomTextField(
                        controller: _upiController,
                        label: 'Receiver UPI ID',
                        hint: 'name@bank',
                        icon: Icons.alternate_email_rounded,
                        keyboardType: TextInputType.emailAddress,
                        validator: Validators.upiId,
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: _amountController,
                        label: 'Amount',
                        hint: '500',
                        icon: Icons.currency_rupee_rounded,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        validator: Validators.amount,
                      ),
                      const SizedBox(height: 24),
                      Consumer<PaymentProvider>(
                        builder: (context, provider, child) {
                          return CustomButton(
                            label: 'Pay now',
                            icon: Icons.lock_rounded,
                            isLoading: provider.isLoading,
                            onPressed: _sendMoney,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 18),
              const _LearningTip(),
            ],
          ),
        ),
      ),
    );
  }
}

class _LearningTip extends StatelessWidget {
  const _LearningTip();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.lightbulb_rounded, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Flow: form validation → PaymentProvider → ApiService POST → '
                'loading/error state → success screen.',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
