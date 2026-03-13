import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/transaction_model.dart';

/// Local cache interface for transactions.
abstract class TransactionLocalCache {
  Future<void> cacheTransactions(List<TransactionModel> transactions);
  List<TransactionModel> getCachedTransactions();
}

/// Local cache implementation for transactions using SharedPreferences.
class TransactionLocalCacheImpl implements TransactionLocalCache {
  const TransactionLocalCacheImpl({required this.prefs});

  final SharedPreferences prefs;

  static const _transactionsKey = 'cached_transactions';

  @override
  Future<void> cacheTransactions(List<TransactionModel> transactions) async {
    final jsonList = transactions.map((t) => t.toJson()).toList();
    await prefs.setString(_transactionsKey, jsonEncode(jsonList));
  }

  @override
  List<TransactionModel> getCachedTransactions() {
    try {
      final jsonString = prefs.getString(_transactionsKey);
      if (jsonString == null) return [];

      final List<dynamic> jsonList = jsonDecode(jsonString) as List<dynamic>;
      return jsonList
          .map((json) => TransactionModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('DEBUG: Error reading cached transactions: $e');
      return [];
    }
  }
}
