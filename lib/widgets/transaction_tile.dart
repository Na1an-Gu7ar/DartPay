import 'package:flutter/material.dart';

import '../models/transaction.dart';

// TransactionTile is used on home, history, and receipt screens.
class TransactionTile extends StatelessWidget {
  final TransactionModel transaction;
  final VoidCallback? onTap;

  const TransactionTile({super.key, required this.transaction, this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final statusColor = switch (transaction.status) {
      TransactionStatus.success => Colors.green,
      TransactionStatus.failed => colorScheme.error,
      TransactionStatus.submitted => Colors.orange,
      TransactionStatus.cancelled => Colors.grey,
    };

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: statusColor.withOpacity(0.12),
          child: Icon(_statusIcon(transaction.status), color: statusColor),
        ),
        title: Text(transaction.receiverName),
        subtitle: Text('${transaction.upiId}\n${transaction.typeLabel} • ${_formatDate(transaction.dateTime)}'),
        isThreeLine: true,
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(transaction.formattedAmount, style: Theme.of(context).textTheme.titleMedium),
            Text(transaction.statusLabel, style: TextStyle(color: statusColor)),
          ],
        ),
      ),
    );
  }

  IconData _statusIcon(TransactionStatus status) {
    return switch (status) {
      TransactionStatus.success => Icons.check_circle_rounded,
      TransactionStatus.failed => Icons.cancel_rounded,
      TransactionStatus.submitted => Icons.schedule_rounded,
      TransactionStatus.cancelled => Icons.block_rounded,
    };
  }

  String _formatDate(DateTime dateTime) {
    final day = dateTime.day.toString().padLeft(2, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$day/$month/${dateTime.year} • $hour:$minute';
  }
}
