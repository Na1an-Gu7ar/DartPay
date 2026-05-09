import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/transaction.dart';

// Persists transaction receipts locally so history survives app restarts.
class TransactionStorageService {
  static const _transactionsKey = 'swiftpay_transactions';

  final SharedPreferences _preferences;

  TransactionStorageService(this._preferences);

  List<TransactionModel> loadTransactions() {
    final rawList = _preferences.getStringList(_transactionsKey) ?? [];

    return rawList
        .map((raw) => TransactionModel.fromJson(jsonDecode(raw) as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveTransactions(List<TransactionModel> transactions) async {
    final rawList = transactions
        .map((transaction) => jsonEncode(transaction.toJson()))
        .toList();
    await _preferences.setStringList(_transactionsKey, rawList);
  }
}
