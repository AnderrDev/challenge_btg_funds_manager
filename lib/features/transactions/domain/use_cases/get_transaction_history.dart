import 'package:btg_funds_manager/core/utils/result.dart';
import 'package:btg_funds_manager/features/transactions/domain/entities/transaction.dart';
import 'package:btg_funds_manager/features/transactions/domain/repositories/transaction_repository.dart';

/// Use case: retrieves the full transaction history.
///
/// Pure function wrapper — delegates to repository.
class GetTransactionHistory {
  const GetTransactionHistory({required this.repository});

  final TransactionRepository repository;

  /// Executes the use case.
  Future<Result<List<Transaction>>> call() =>
      repository.getTransactionHistory();
}
