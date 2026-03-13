import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:btg_funds_manager/features/funds/domain/entities/fund.dart';

/// Local cache for funds using SharedPreferences.
///
/// Stores funds list and user balance as JSON strings for offline access
/// and fast startup before API data arrives.
class FundLocalCache {
  const FundLocalCache({required this.prefs});

  final SharedPreferences prefs;

  static const _fundsKey = 'cached_funds';
  static const _balanceKey = 'cached_balance';

  /// Caches the list of funds.
  Future<void> cacheFunds(List<Fund> funds) async {
    final jsonList = funds.map((f) => f.toJson()).toList();
    await prefs.setString(_fundsKey, jsonEncode(jsonList));
  }

  /// Returns cached funds, or empty list if none cached.
  List<Fund> getCachedFunds() {
    final jsonString = prefs.getString(_fundsKey);
    if (jsonString == null) return [];

    final List<dynamic> jsonList = jsonDecode(jsonString) as List<dynamic>;
    return jsonList
        .map((json) => Fund.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Returns a cached fund by [id], or null if not found.
  Fund? getCachedFundById(int id) {
    final funds = getCachedFunds();
    try {
      return funds.firstWhere((f) => f.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Caches the user's balance.
  Future<void> cacheBalance(double balance) async {
    await prefs.setDouble(_balanceKey, balance);
  }

  /// Returns cached balance, or null if none cached.
  double? getCachedBalance() {
    return prefs.getDouble(_balanceKey);
  }
}
