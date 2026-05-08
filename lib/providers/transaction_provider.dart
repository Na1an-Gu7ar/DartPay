import 'package:flutter/foundation.dart';

import '../models/transaction.dart';
import '../services/api_service.dart';

// TransactionProvider handles API loading, errors, searching, and filtering.
class TransactionProvider extends ChangeNotifier {
  final ApiService _apiService;

  List<TransactionModel> _transactions = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _searchQuery = '';
  TransactionStatus? _selectedStatus;

  TransactionProvider(this._apiService);

  List<TransactionModel> get transactions => _transactions;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;
  TransactionStatus? get selectedStatus => _selectedStatus;

  List<TransactionModel> get filteredTransactions {
    return _transactions.where((transaction) {
      final matchesSearch = transaction.upiId.toLowerCase().contains(_searchQuery) ||
          transaction.receiverName.toLowerCase().contains(_searchQuery);
      final matchesStatus = _selectedStatus == null || transaction.status == _selectedStatus;
      return matchesSearch && matchesStatus;
    }).toList();
  }

  Future<void> fetchTransactions() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _transactions = await _apiService.fetchTransactions();
    } on ApiException catch (error) {
      _errorMessage = error.message;
    } catch (_) {
      _errorMessage = 'Something went wrong while loading transactions';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void addTransaction(TransactionModel transaction) {
    _transactions.insert(0, transaction);
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
}
