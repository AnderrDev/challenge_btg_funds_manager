import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:btg_funds_manager/features/transactions/domain/entities/transaction.dart';

/// Local cache for transactions using SharedPreferences.
///
/// Stores transaction history as a JSON string for offline access.
class TransactionLocalCache {
  const TransactionLocalCache({required this.prefs});

  final SharedPreferences prefs;

  static const _transactionsKey = 'cached_transactions';

  /// Caches the full transaction list.
  Future<void> cacheTransactions(List<Transaction> transactions) async {
    final jsonList = transactions.map((t) => t.toJson()).toList();
    await prefs.setString(_transactionsKey, jsonEncode(jsonList));
  }

  /// Returns cached transactions, or empty list if none cached.
  List<Transaction> getCachedTransactions() {
    final jsonString = prefs.getString(_transactionsKey);
    if (jsonString == null) return [];

    final List<dynamic> jsonList = jsonDecode(jsonString) as List<dynamic>;
    return jsonList
        .map((json) => Transaction.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
