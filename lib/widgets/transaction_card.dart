import 'package:flutter/material.dart';

import '../models/transaction.dart';

// Reusable card for one transaction row.
class TransactionCard extends StatelessWidget {
  final TransactionModel transaction;

  const TransactionCard({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: colorScheme.primaryContainer,
          child: Icon(
            Icons.arrow_upward_rounded,
            color: colorScheme.onPrimaryContainer,
          ),
        ),
        title: Text(transaction.upiId),
        subtitle: Text(_formatDate(transaction.dateTime)),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              transaction.formattedAmount,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              transaction.status,
              style: TextStyle(color: colorScheme.primary),
            ),
          ],
        ),
      ),
    );
  }

  // A basic date formatter avoids adding packages and keeps the app simple.
  String _formatDate(DateTime dateTime) {
    final day = dateTime.day.toString().padLeft(2, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');

    return '$day/$month/${dateTime.year} • $hour:$minute';
  }
}
