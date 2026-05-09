import 'package:flutter/foundation.dart';

import '../models/transaction.dart';
import '../services/api_service.dart';
import '../services/transaction_storage_service.dart';

// TransactionProvider handles API loading, local persistence, search, filters, and retry updates.
class TransactionProvider extends ChangeNotifier {
  final ApiService _apiService;
  final TransactionStorageService _storageService;

  List<TransactionModel> _transactions = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _searchQuery = '';
  TransactionStatus? _selectedStatus;

  TransactionProvider(this._apiService, this._storageService) {
    _transactions = _storageService.loadTransactions();
  }

  List<TransactionModel> get transactions => _transactions;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;
  TransactionStatus? get selectedStatus => _selectedStatus;

  List<TransactionModel> get filteredTransactions {
    return _transactions.where((transaction) {
      final query = _searchQuery.toLowerCase();
      final matchesSearch = transaction.upiId.toLowerCase().contains(query) ||
          transaction.receiverName.toLowerCase().contains(query) ||
          transaction.id.toLowerCase().contains(query);
      final matchesStatus = _selectedStatus == null || transaction.status == _selectedStatus;
      return matchesSearch && matchesStatus;
    }).toList();
  }

  Future<void> fetchTransactions() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final apiTransactions = await _apiService.fetchTransactions();
      // Keep local real-payment receipts first, then append fake API examples.
      final localIds = _transactions.map((transaction) => transaction.id).toSet();
      _transactions = [
        ..._transactions,
        ...apiTransactions.where((transaction) => !localIds.contains(transaction.id)),
      ];
      await _save();
    } on ApiException catch (error) {
      _errorMessage = error.message;
    } catch (_) {
      _errorMessage = 'Something went wrong while loading transactions';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addTransaction(TransactionModel transaction) async {
    _transactions.removeWhere((item) => item.id == transaction.id);
    _transactions.insert(0, transaction);
    await _save();
    notifyListeners();
  }

  Future<void> updateTransactionStatus(String id, TransactionStatus status) async {
    _transactions = _transactions
        .map((transaction) => transaction.id == id ? transaction.copyWith(status: status) : transaction)
        .toList();
    await _save();
    notifyListeners();
  }

  void updateSearch(String value) {
    _searchQuery = value.trim().toLowerCase();
    notifyListeners();
  }

  void updateFilter(TransactionStatus? status) {
    _selectedStatus = status;
    notifyListeners();
  }

  Future<void> _save() async {
    await _storageService.saveTransactions(_transactions);
  }
}
