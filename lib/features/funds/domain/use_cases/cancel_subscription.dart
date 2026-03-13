import 'package:btg_funds_manager/core/utils/result.dart';
import 'package:btg_funds_manager/features/transactions/domain/entities/transaction.dart';
import 'package:btg_funds_manager/features/transactions/data/datasources/transaction_local_datasource.dart';
import 'package:btg_funds_manager/features/funds/domain/entities/fund.dart';
import 'package:btg_funds_manager/features/funds/domain/repositories/fund_repository.dart';

/// Use case: cancels the user's subscription to a fund.
///
/// Business rules:
/// - On cancellation, the fund's minimum amount is returned to the user's balance.
/// - A cancellation transaction is recorded.
class CancelSubscription {
  const CancelSubscription({
    required this.fundRepository,
    required this.transactionDataSource,
  });

  final FundRepository fundRepository;
  final TransactionLocalDataSource transactionDataSource;

  /// Executes the cancellation.
  Future<Result<Fund>> call({
    required int fundId,
    required double currentBalance,
    required String fundName,
    required double fundMinimumAmount,
  }) async {
    final result = await fundRepository.cancelSubscription(fundId: fundId);

    switch (result) {
      case Success(data: final fund):
        // Credit balance back
        final newBalance = currentBalance + fundMinimumAmount;
        await fundRepository.updateBalance(newBalance);

        // Record cancellation transaction
        final transaction = Transaction(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          fundId: fund.id,
          fundName: fund.name,
          type: TransactionType.cancellation,
          amount: fundMinimumAmount,
          date: DateTime.now(),
        );
        await transactionDataSource.addTransaction(transaction);

        return Success(fund);

      case Failure(message: final msg):
        return Failure(msg);
    }
  }
}
