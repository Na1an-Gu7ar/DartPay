import 'package:flutter/material.dart';

import '../models/transaction.dart';
import '../services/transaction_service.dart';
import '../widgets/primary_button.dart';
import 'success_screen.dart';

// SendMoneyScreen collects a UPI ID and amount from the user.
class SendMoneyScreen extends StatefulWidget {
  final ValueChanged<TransactionModel> onTransactionCreated;

  const SendMoneyScreen({super.key, required this.onTransactionCreated});

  @override
  State<SendMoneyScreen> createState() => _SendMoneyScreenState();
}

class _SendMoneyScreenState extends State<SendMoneyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _upiController = TextEditingController();
  final _amountController = TextEditingController();
  final _transactionService = const TransactionService();

  @override
  void dispose() {
    _upiController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _sendMoney() {
    // validate() runs every validator inside the Form.
    if (!_formKey.currentState!.validate()) return;

    final transaction = _transactionService.createTransaction(
      upiId: _upiController.text.trim(),
      amount: double.parse(_amountController.text.trim()),
    );

    widget.onTransactionCreated(transaction);

    // Clear inputs so the form is empty when the user returns.
    _upiController.clear();
    _amountController.clear();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SuccessScreen(transaction: transaction),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Send money',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Enter a UPI ID and amount to create a sample payment.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _upiController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'UPI ID',
                        hintText: 'name@bank',
                        prefixIcon: Icon(Icons.alternate_email_rounded),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a UPI ID';
                        }
                        if (!value.contains('@')) {
                          return 'UPI ID should contain @';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _amountController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Amount',
                        hintText: '500',
                        prefixIcon: Icon(Icons.currency_rupee_rounded),
                      ),
                      validator: (value) {
                        final amount = double.tryParse(value?.trim() ?? '');
                        if (amount == null) {
                          return 'Please enter a valid amount';
                        }
                        if (amount <= 0) {
                          return 'Amount must be greater than zero';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    PrimaryButton(
                      label: 'Pay now',
                      icon: Icons.lock_rounded,
                      onPressed: _sendMoney,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const _LearningNote(),
          ],
        ),
      ),
    );
  }
}

class _LearningNote extends StatelessWidget {
  const _LearningNote();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.info_outline_rounded,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Learning note: this screen uses TextEditingController, Form, '
                'validators, Navigator, and setState from the parent app.',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
