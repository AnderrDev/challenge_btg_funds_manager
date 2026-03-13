import 'package:btg_funds_manager/features/funds/domain/entities/fund.dart';
import 'package:btg_funds_manager/core/constants/app_constants.dart';

/// Local mock data source for funds.
///
/// Simulates a REST API with in-memory data.
/// Contains the 5 funds specified in the technical test.
class FundLocalDataSource {
  // In-memory state
  List<Fund> _funds = [
    const Fund(
      id: 1,
      name: 'FPV_BTG_PACTUAL_RECAUDADORA',
      minimumAmount: 75000,
      category: FundCategory.fpv,
    ),
    const Fund(
      id: 2,
      name: 'FPV_BTG_PACTUAL_ECOPETROL',
      minimumAmount: 125000,
      category: FundCategory.fpv,
    ),
    const Fund(
      id: 3,
      name: 'DEUDAPRIVADA',
      minimumAmount: 50000,
      category: FundCategory.fic,
    ),
    const Fund(
      id: 4,
      name: 'FDO-ACCIONES',
      minimumAmount: 250000,
      category: FundCategory.fic,
    ),
    const Fund(
      id: 5,
      name: 'FPV_BTG_PACTUAL_DINAMICA',
      minimumAmount: 100000,
      category: FundCategory.fpv,
    ),
  ];

  double _balance = AppConstants.initialBalance;

  /// Simulates network delay and returns all funds.
  Future<List<Fund>> getFunds() async {
    await Future.delayed(const Duration(milliseconds: 800));
    return List.unmodifiable(_funds);
  }

  /// Marks a fund as subscribed.
  Future<Fund> subscribeTo(int fundId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _funds = _funds.map((f) {
      if (f.id == fundId) return f.copyWith(isSubscribed: true);
      return f;
    }).toList();
    return _funds.firstWhere((f) => f.id == fundId);
  }

  /// Marks a fund as unsubscribed.
  Future<Fund> cancelSubscription(int fundId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _funds = _funds.map((f) {
      if (f.id == fundId) return f.copyWith(isSubscribed: false);
      return f;
    }).toList();
    return _funds.firstWhere((f) => f.id == fundId);
  }

  /// Returns current balance.
  double getBalance() => _balance;

  /// Updates balance.
  void updateBalance(double newBalance) {
    _balance = newBalance;
  }
}
