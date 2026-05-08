import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/transaction.dart';
import '../providers/transaction_provider.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/loading_widget.dart';
import '../widgets/transaction_tile.dart';

// History screen demonstrates GET loading, search, filters, empty, and error states.
class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Transaction history')),
      body: Consumer<TransactionProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.transactions.isEmpty) {
            return const LoadingWidget(message: 'Fetching transactions...');
          }

          if (provider.errorMessage != null && provider.transactions.isEmpty) {
            return EmptyStateWidget(
              icon: Icons.wifi_off_rounded,
              title: 'Unable to load history',
              message: provider.errorMessage!,
              actionLabel: 'Try again',
              onActionPressed: provider.fetchTransactions,
            );
          }

          return RefreshIndicator(
            onRefresh: provider.fetchTransactions,
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                TextField(
                  onChanged: provider.updateSearch,
                  decoration: const InputDecoration(
                    labelText: 'Search transactions',
                    hintText: 'Search UPI ID or name',
                    prefixIcon: Icon(Icons.search_rounded),
                  ),
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ChoiceChip(
                        label: const Text('All'),
                        selected: provider.selectedStatus == null,
                        onSelected: (_) => provider.updateFilter(null),
                      ),
                      const SizedBox(width: 8),
                      ...TransactionStatus.values.map(
                        (status) => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(status.name[0].toUpperCase() + status.name.substring(1)),
                            selected: provider.selectedStatus == status,
                            onSelected: (_) => provider.updateFilter(status),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                if (provider.filteredTransactions.isEmpty)
                  const EmptyStateWidget(
                    icon: Icons.search_off_rounded,
                    title: 'No matching transactions',
                    message: 'Try changing the search text or filter.',
                  )
                else
                  ...provider.filteredTransactions.map(
                    (transaction) => TransactionTile(transaction: transaction),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
