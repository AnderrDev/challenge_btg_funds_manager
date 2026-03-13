import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/fund_model.dart';

/// Local cache interface for funds.
abstract class FundLocalCache {
  Future<void> cacheFunds(List<FundModel> funds);
  List<FundModel> getCachedFunds();
  FundModel? getCachedFundById(int id);
  Future<void> cacheBalance(double balance);
  double? getCachedBalance();
}

/// Local cache implementation for funds using SharedPreferences.
class FundLocalCacheImpl implements FundLocalCache {
  const FundLocalCacheImpl({required this.prefs});

  final SharedPreferences prefs;

  static const _fundsKey = 'cached_funds';
  static const _balanceKey = 'cached_balance';

  @override
  Future<void> cacheFunds(List<FundModel> funds) async {
    final jsonList = funds.map((f) => f.toJson()).toList();
    await prefs.setString(_fundsKey, jsonEncode(jsonList));
  }

  @override
  List<FundModel> getCachedFunds() {
    final jsonString = prefs.getString(_fundsKey);
    if (jsonString == null) return [];

    final List<dynamic> jsonList = jsonDecode(jsonString) as List<dynamic>;
    return jsonList
        .map((json) => FundModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  FundModel? getCachedFundById(int id) {
    final funds = getCachedFunds();
    try {
      return funds.firstWhere((f) => f.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> cacheBalance(double balance) async {
    await prefs.setDouble(_balanceKey, balance);
  }

  @override
  double? getCachedBalance() {
    return prefs.getDouble(_balanceKey);
  }
}
