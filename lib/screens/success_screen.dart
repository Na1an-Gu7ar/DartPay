import 'package:flutter/material.dart';

import '../models/transaction.dart';
import '../widgets/primary_button.dart';

// This screen confirms that the sample payment was successful.
class SuccessScreen extends StatelessWidget {
  final TransactionModel transaction;

  const SuccessScreen({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Payment status')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Spacer(),
            CircleAvatar(
              radius: 52,
              backgroundColor: colorScheme.primaryContainer,
              child: Icon(
                Icons.check_rounded,
                size: 64,
                color: colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Payment successful!',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              '${transaction.formattedAmount} sent to ${transaction.upiId}',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _DetailRow(label: 'Transaction ID', value: transaction.id),
                    const Divider(height: 28),
                    _DetailRow(label: 'Status', value: transaction.status),
                    const Divider(height: 28),
                    _DetailRow(label: 'UPI ID', value: transaction.upiId),
                  ],
                ),
              ),
            ),
            const Spacer(),
            PrimaryButton(
              label: 'Back to DartPay',
              icon: Icons.home_rounded,
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
