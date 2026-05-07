import 'package:flutter/material.dart';

import '../models/transaction.dart';
import '../widgets/transaction_card.dart';

// Home screen shows the balance card, quick actions, and recent transactions.
class HomeScreen extends StatelessWidget {
  final List<TransactionModel> transactions;
  final VoidCallback onSendMoneyTap;
  final VoidCallback onHistoryTap;

  const HomeScreen({
    super.key,
    required this.transactions,
    required this.onSendMoneyTap,
    required this.onHistoryTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final recentTransactions = transactions.take(3).toList();

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Card(
          color: colorScheme.primaryContainer,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Available balance',
                  style: TextStyle(color: colorScheme.onPrimaryContainer),
                ),
                const SizedBox(height: 10),
                Text(
                  '₹24,580.50',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    FilledButton.icon(
                      onPressed: onSendMoneyTap,
                      icon: const Icon(Icons.send_rounded),
                      label: const Text('Send money'),
                    ),
                    const SizedBox(width: 12),
                    OutlinedButton.icon(
                      onPressed: onHistoryTap,
                      icon: const Icon(Icons.history_rounded),
                      label: const Text('History'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Quick actions',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _QuickActionCard(
              icon: Icons.qr_code_scanner_rounded,
              label: 'Scan',
              onTap: onSendMoneyTap,
            ),
            const SizedBox(width: 12),
            _QuickActionCard(
              icon: Icons.person_add_alt_1_rounded,
              label: 'UPI ID',
              onTap: onSendMoneyTap,
            ),
            const SizedBox(width: 12),
            _QuickActionCard(
              icon: Icons.account_balance_wallet_rounded,
              label: 'Wallet',
              onTap: () {},
            ),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent activity',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            TextButton(
              onPressed: onHistoryTap,
              child: const Text('View all'),
            ),
          ],
        ),
        if (recentTransactions.isEmpty)
          const _EmptyRecentTransactions()
        else
          ...recentTransactions.map(
            (transaction) => TransactionCard(transaction: transaction),
          ),
      ],
    );
  }
}

// Private reusable widget for the small action cards on the home screen.
class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 18),
            child: Column(
              children: [
                Icon(icon, size: 30),
                const SizedBox(height: 8),
                Text(label),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyRecentTransactions extends StatelessWidget {
  const _EmptyRecentTransactions();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(
              Icons.receipt_long_rounded,
              size: 42,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 12),
            const Text('No transactions yet. Send your first payment!'),
          ],
        ),
      ),
    );
  }
}
