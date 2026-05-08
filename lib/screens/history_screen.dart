import 'package:flutter/material.dart';

import '../models/transaction.dart';
import '../widgets/transaction_card.dart';

// Shows all successful payments in a simple list.
class HistoryScreen extends StatelessWidget {
  final List<TransactionModel> transactions;

  const HistoryScreen({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return const _EmptyHistory();
    }

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          'Transaction history',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        ...transactions.map(
          (transaction) => TransactionCard(transaction: transaction),
        ),
      ],
    );
  }
}

class _EmptyHistory extends StatelessWidget {
  const _EmptyHistory();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.history_rounded,
              size: 72,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'No transactions yet',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            const Text(
              'Your successful DartPay transfers will appear here.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
