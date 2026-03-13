import 'package:btg_funds_manager/core/utils/result.dart';
import 'package:btg_funds_manager/features/funds/domain/entities/fund.dart';
import 'package:btg_funds_manager/features/transactions/domain/entities/transaction.dart';

/// Abstract contract for fund data operations.
///
/// Defines the interface that the data layer must implement.
/// Domain layer depends on this abstraction, not on concrete implementations.
abstract class FundRepository {
  /// Returns the list of all available funds.
  Future<Result<List<Fund>>> getFunds();

  /// Returns a single fund by [id] with full details.
  Future<Result<Fund>> getFundById(int id);

  /// Subscribes the user to a fund by [fundId].
  ///
  /// The [method] determines which notification channel is used.
  /// Returns a failure if the user does not have sufficient balance.
  Future<Result<Fund>> subscribeTo({
    required int fundId,
    required NotificationMethod method,
    required double currentBalance,
  });

  /// Cancels the user's subscription to a fund by [fundId].
  Future<Result<Fund>> cancelSubscription({required int fundId});

  /// Returns the current available balance for the user.
  Future<double> getBalance();

  /// Updates the user's balance.
  Future<void> updateBalance(double newBalance);
}
