import 'package:btg_funds_manager/core/utils/result.dart';
import 'package:btg_funds_manager/features/transactions/domain/entities/transaction.dart';

/// Abstract contract for transaction data operations.
abstract class TransactionRepository {
  /// Returns the full transaction history, ordered by date descending.
  Future<Result<List<Transaction>>> getTransactionHistory();

  /// Records a new transaction.
  Future<void> addTransaction(Transaction transaction);
}
