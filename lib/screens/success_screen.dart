import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/payment_model.dart';
import '../models/transaction.dart';
import '../routes/app_routes.dart';
import '../widgets/custom_button.dart';

// Success screen receives PaymentModel through GoRouter's extra parameter.
class SuccessScreen extends StatelessWidget {
  final PaymentModel? payment;

  const SuccessScreen({super.key, required this.payment});

  @override
  Widget build(BuildContext context) {
    final transaction = payment?.transaction;
    final status = transaction?.status ?? TransactionStatus.failed;
    final isSuccess = status == TransactionStatus.success;
    final isPending = status == TransactionStatus.pending;
    final colorScheme = Theme.of(context).colorScheme;
    final statusColor = isSuccess
        ? Colors.green
        : isPending
            ? Colors.orange
            : colorScheme.error;

    return Scaffold(
      appBar: AppBar(title: const Text('Payment status')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Spacer(),
            CircleAvatar(
              radius: 54,
              backgroundColor: statusColor.withOpacity(0.12),
              child: Icon(
                isSuccess
                    ? Icons.check_rounded
                    : isPending
                        ? Icons.schedule_rounded
                        : Icons.close_rounded,
                color: statusColor,
                size: 64,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              payment?.message ?? 'Payment details are unavailable',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            if (transaction != null)
              Text(
                '${transaction.formattedAmount} to ${transaction.upiId}',
                textAlign: TextAlign.center,
              ),
            const SizedBox(height: 24),
            if (transaction != null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _DetailRow(label: 'Transaction ID', value: transaction.id),
                      const Divider(height: 28),
                      _DetailRow(label: 'Status', value: transaction.statusLabel),
                      const Divider(height: 28),
                      _DetailRow(label: 'Receiver', value: transaction.receiverName),
                      const Divider(height: 28),
                      _DetailRow(label: 'Note', value: transaction.note),
                      // const Divider(height: 28),
                      // _DetailRow(label: 'Receiver', value: transaction.),
                    ],
                  ),
                ),
              ),
            const Spacer(),
            CustomButton(
              label: 'Back to dashboard',
              icon: Icons.home_rounded,
              onPressed: () => context.go(AppRoutes.dashboard),
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
