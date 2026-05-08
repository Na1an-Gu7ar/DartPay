import 'package:flutter/material.dart';

import '../models/transaction.dart';
import 'history_screen.dart';
import 'home_screen.dart';
import 'send_money_screen.dart';

// DashboardScreen owns the bottom navigation bar.
// It switches between Home, Send Money, and History using setState.
class DashboardScreen extends StatefulWidget {
  static const routeName = '/dashboard';

  final bool isDarkMode;
  final List<TransactionModel> transactions;
  final VoidCallback onThemeToggle;
  final ValueChanged<TransactionModel> onTransactionCreated;

  const DashboardScreen({
    super.key,
    required this.isDarkMode,
    required this.transactions,
    required this.onThemeToggle,
    required this.onTransactionCreated,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  void _changeTab(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeScreen(
        transactions: widget.transactions,
        onSendMoneyTap: () => _changeTab(1),
        onHistoryTap: () => _changeTab(2),
      ),
      SendMoneyScreen(onTransactionCreated: widget.onTransactionCreated),
      HistoryScreen(transactions: widget.transactions),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('DartPay'),
        actions: [
          IconButton(
            tooltip: 'Toggle theme',
            onPressed: widget.onThemeToggle,
            icon: Icon(
              widget.isDarkMode
                  ? Icons.light_mode_rounded
                  : Icons.dark_mode_rounded,
            ),
          ),
        ],
      ),
      body: IndexedStack(
        // IndexedStack keeps each tab alive while the user switches tabs.
        index: _selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _changeTab,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.send_outlined),
            selectedIcon: Icon(Icons.send_rounded),
            label: 'Send',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long_rounded),
            label: 'History',
          ),
        ],
      ),
    );
  }
}
