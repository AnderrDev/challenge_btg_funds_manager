import 'package:btg_funds_manager/core/utils/result.dart';
import 'package:btg_funds_manager/features/transactions/domain/entities/transaction.dart';
import 'package:btg_funds_manager/features/transactions/domain/repositories/transaction_repository.dart';
import 'package:btg_funds_manager/features/funds/domain/entities/fund.dart';
import 'package:btg_funds_manager/features/funds/domain/repositories/fund_repository.dart';

/// Use case: subscribes the user to a fund.
///
/// Business rules:
/// - The user's current balance must be ≥ the fund's minimum amount.
/// - On success, balance is debited and a transaction is recorded.
class SubscribeToFund {
  const SubscribeToFund({
    required this.fundRepository,
    required this.transactionRepository,
  });

  final FundRepository fundRepository;
  final TransactionRepository transactionRepository;

  /// Executes the subscription.
  ///
  /// Returns [Failure] if the user has insufficient balance.
  Future<Result<Fund>> call({
    required int fundId,
    required NotificationMethod method,
    required double currentBalance,
    required String fundName,
    required double fundMinimumAmount,
  }) async {
    // Business rule: validate sufficient balance
    if (currentBalance < fundMinimumAmount) {
      return Failure(
        'No tiene saldo disponible para vincularse al fondo $fundName',
      );
    }

    final result = await fundRepository.subscribeTo(
      fundId: fundId,
      method: method,
      currentBalance: currentBalance,
    );

    switch (result) {
      case Success(data: final fund):
        // Debit balance
        final newBalance = currentBalance - fund.minimumAmount;
        await fundRepository.updateBalance(newBalance);

        // Record transaction
        final transaction = Transaction(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          fundId: fund.id,
          fundName: fund.name,
          type: TransactionType.subscription,
          amount: fund.minimumAmount,
          date: DateTime.now(),
          notificationMethod: method,
        );
        await transactionRepository.addTransaction(transaction);

        return Success(fund);

      case Failure(message: final msg):
        return Failure(msg);
    }
  }
}
