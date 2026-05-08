import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;

import '../models/payment_model.dart';
import '../models/transaction.dart';

// A custom exception gives providers a clean message to show in the UI.
class ApiException implements Exception {
  final String message;

  const ApiException(this.message);

  @override
  String toString() => message;
}

// ApiService demonstrates GET and POST with the http package.
// jsonplaceholder is used only as a safe fake API for learning.
class ApiService {
  static const _baseUrl = 'https://jsonplaceholder.typicode.com';
  final http.Client _client;

  ApiService({http.Client? client}) : _client = client ?? http.Client();

  // GET example: fetch fake data and convert it into transaction models.
  Future<List<TransactionModel>> fetchTransactions() async {
    try {
      // Future.delayed makes the loading state visible while learning.
      await Future.delayed(const Duration(milliseconds: 800));

      final response = await _client.get(Uri.parse('$_baseUrl/posts?_limit=8'));

      if (response.statusCode != 200) {
        throw const ApiException('Unable to load transactions');
      }

      final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
      return List.generate(data.length, (index) {
        final item = data[index] as Map<String, dynamic>;
        final status = TransactionStatus.values[index % TransactionStatus.values.length];

        return TransactionModel(
          id: item['id'].toString(),
          receiverName: 'Receiver ${item['id']}',
          upiId: 'receiver${item['id']}@upi',
          amount: 125.0 + (index * 87.50),
          dateTime: DateTime.now().subtract(Duration(days: index)),
          status: status,
          note: item['title'] as String? ?? 'UPI payment',
        );
      });
    } on ApiException {
      rethrow;
    } catch (_) {
      throw const ApiException('Check your internet connection and try again');
    }
  }

  // POST example: send a fake payment request and return a payment result.
  Future<PaymentModel> sendPayment({
    required String upiId,
    required double amount,
    required String note
  }) async {
    try {
      await Future.delayed(const Duration(seconds: 1));

      final response = await _client.post(
        Uri.parse('$_baseUrl/posts'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'upiId': upiId, 'amount': amount, 'note': note}),
      );

      if (response.statusCode != 201) {
        throw const ApiException('Payment server rejected the request');
      }

      // Random status helps learners see success, pending, and failure states.
      final random = Random();
      final status = random.nextInt(10) < 7
          ? TransactionStatus.success
          : random.nextBool()
              ? TransactionStatus.pending
              : TransactionStatus.failed;
      final transaction = TransactionModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        receiverName: upiId.split('@').first,
        upiId: upiId,
        amount: amount,
        dateTime: DateTime.now(),
        status: status,
        note: note
      );

      return PaymentModel(
        isSuccess: status == TransactionStatus.success,
        message: status == TransactionStatus.success
            ? 'Payment completed successfully'
            : status == TransactionStatus.pending
                ? 'Payment is pending confirmation'
                : 'Payment failed. Please try again.',
        transaction: transaction,
      );
    } on ApiException {
      rethrow;
    } catch (_) {
      throw const ApiException('Payment failed because the network is unavailable');
    }
  }
}