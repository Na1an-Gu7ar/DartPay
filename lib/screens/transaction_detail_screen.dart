import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../models/payment_request.dart';
import '../models/transaction.dart';
import '../routes/app_routes.dart';
import '../utils/snackbar_helper.dart';
import '../widgets/custom_button.dart';
import '../widgets/empty_state_widget.dart';

// Receipt screen teaches copy/share actions and retrying failed payments.
class TransactionDetailScreen extends StatelessWidget {
  final TransactionModel? transaction;

  const TransactionDetailScreen({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final item = transaction;
    if (item == null) {
      return const Scaffold(
        body: EmptyStateWidget(
          icon: Icons.receipt_long_rounded,
          title: 'Receipt not found',
          message: 'Open a transaction from history to view details.',
        ),
      );
    }

    final canRetry = item.status == TransactionStatus.failed ||
        item.status == TransactionStatus.cancelled;

    return Scaffold(
      appBar: AppBar(title: const Text('Payment receipt')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Icon(_iconForStatus(item.status), size: 72, color: _colorForStatus(context, item.status)),
                  const SizedBox(height: 16),
                  Text(item.formattedAmount, style: Theme.of(context).textTheme.displaySmall),
                  const SizedBox(height: 8),
                  Text(item.statusLabel, style: TextStyle(color: _colorForStatus(context, item.status))),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                children: [
                  _ReceiptRow(label: 'Receiver', value: item.receiverName),
                  _ReceiptRow(label: 'UPI ID', value: item.upiId),
                  _ReceiptRow(label: 'Payment method', value: item.typeLabel),
                  _ReceiptRow(label: 'Note', value: item.note),
                  _ReceiptRow(label: 'Transaction ID', value: item.id),
                  if (item.gatewayPaymentId != null)
                    _ReceiptRow(label: 'Gateway ID', value: item.gatewayPaymentId!),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),
          OutlinedButton.icon(
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: item.id));
              if (context.mounted) showAppSnackBar(context, 'Transaction ID copied');
            },
            icon: const Icon(Icons.copy_rounded),
            label: const Text('Copy transaction ID'),
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: () => Share.share(_receiptText(item)),
            icon: const Icon(Icons.share_rounded),
            label: const Text('Share receipt'),
          ),
          if (canRetry) ...[
            const SizedBox(height: 10),
            CustomButton(
              label: 'Retry payment',
              icon: Icons.refresh_rounded,
              onPressed: () {
                context.push(
                  AppRoutes.sendMoney,
                  extra: PaymentRequest(
                    upiId: item.upiId,
                    receiverName: item.receiverName,
                    amount: item.amount,
                    note: item.note,
                  ),
                );
              },
            ),
          ],
        ],
      ),
    );
  }

  String _receiptText(TransactionModel item) {
    return 'dartpay receipt\n'
        'Amount: ${item.formattedAmount}\n'
        'Receiver: ${item.receiverName}\n'
        'UPI ID: ${item.upiId}\n'
        'Status: ${item.statusLabel}\n'
        'Transaction ID: ${item.id}';
  }

  IconData _iconForStatus(TransactionStatus status) {
    return switch (status) {
      TransactionStatus.success => Icons.check_circle_rounded,
      TransactionStatus.failed => Icons.cancel_rounded,
      TransactionStatus.submitted => Icons.schedule_rounded,
      TransactionStatus.cancelled => Icons.block_rounded,
    };
  }

  Color _colorForStatus(BuildContext context, TransactionStatus status) {
    return switch (status) {
      TransactionStatus.success => Colors.green,
      TransactionStatus.failed => Theme.of(context).colorScheme.error,
      TransactionStatus.submitted => Colors.orange,
      TransactionStatus.cancelled => Colors.grey,
    };
  }
}

class _ReceiptRow extends StatelessWidget {
  final String label;
  final String value;

  const _ReceiptRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          const SizedBox(width: 16),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
