import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../providers/transaction_provider.dart';
import '../routes/app_routes.dart';
import '../utils/app_constants.dart';
import '../widgets/balance_card.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/loading_widget.dart';
import '../widgets/transaction_tile.dart';

// Home screen demonstrates Consumer, pull-to-refresh, and recent transactions.
class HomeScreen extends StatelessWidget {
  final ValueChanged<int> onNavigateToTab;

  const HomeScreen({super.key, required this.onNavigateToTab});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appName),
        actions: [
          IconButton(
            tooltip: 'Profile',
            onPressed: () => onNavigateToTab(3),
            icon: const Icon(Icons.person_rounded),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => context.read<TransactionProvider>().fetchTransactions(),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              'Hello, ${user?.name ?? 'Learner'}',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            const Text('Welcome back to your UPI dashboard.'),
            const SizedBox(height: 20),
            BalanceCard(
              balance: AppConstants.demoBalance,
              onSendMoneyTap: () => onNavigateToTab(1),
              onQrTap: () => context.push(AppRoutes.qrScanner),
            ),
            const SizedBox(height: 24),
            Text('Quick actions', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            Row(
              children: [
                _QuickAction(icon: Icons.send_rounded, label: 'Send', onTap: () => onNavigateToTab(1)),
                const SizedBox(width: 12),
                _QuickAction(icon: Icons.history_rounded, label: 'History', onTap: () => onNavigateToTab(2)),
                const SizedBox(width: 12),
                _QuickAction(icon: Icons.qr_code_rounded, label: 'QR', onTap: () => context.push(AppRoutes.qrScanner)),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Recent transactions', style: Theme.of(context).textTheme.titleLarge),
                TextButton(onPressed: () => onNavigateToTab(2), child: const Text('View all')),
              ],
            ),
            Consumer<TransactionProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading && provider.transactions.isEmpty) {
                  return const SizedBox(height: 220, child: LoadingWidget(message: 'Loading recent activity...'));
                }
                if (provider.errorMessage != null && provider.transactions.isEmpty) {
                  return EmptyStateWidget(
                    icon: Icons.wifi_off_rounded,
                    title: 'Could not load data',
                    message: provider.errorMessage!,
                    actionLabel: 'Retry',
                    onActionPressed: provider.fetchTransactions,
                  );
                }
                final recent = provider.transactions.take(3).toList();
                if (recent.isEmpty) {
                  return const EmptyStateWidget(
                    icon: Icons.receipt_long_rounded,
                    title: 'No payments yet',
                    message: 'Send money to see recent activity here.',
                  );
                }
                return Column(
                  children: recent.map((item) => TransactionTile(transaction: item)).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickAction({required this.icon, required this.label, required this.onTap});

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
