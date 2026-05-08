import 'package:flutter/material.dart';

// BalanceCard keeps the hero card reusable and easy to read.
class BalanceCard extends StatelessWidget {
  final double balance;
  final VoidCallback onSendMoneyTap;
  final VoidCallback onQrTap;

  const BalanceCard({
    super.key,
    required this.balance,
    required this.onSendMoneyTap,
    required this.onQrTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      color: colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Available balance', style: TextStyle(color: colorScheme.onPrimaryContainer)),
            const SizedBox(height: 10),
            Text(
              '₹${balance.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: onSendMoneyTap,
                    icon: const Icon(Icons.send_rounded),
                    label: const Text('Send'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onQrTap,
                    icon: const Icon(Icons.qr_code_scanner_rounded),
                    label: const Text('Scan QR'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
