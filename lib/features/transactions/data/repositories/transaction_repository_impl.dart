import 'package:btg_funds_manager/core/utils/result.dart';
import 'package:btg_funds_manager/features/transactions/domain/entities/transaction.dart';
import 'package:btg_funds_manager/features/transactions/domain/repositories/transaction_repository.dart';
import 'package:btg_funds_manager/features/transactions/data/datasources/transaction_local_datasource.dart';

/// Concrete implementation of [TransactionRepository].
///
/// Bridges the domain layer with the local transaction data source.
class TransactionRepositoryImpl implements TransactionRepository {
  const TransactionRepositoryImpl({required this.dataSource});

  final TransactionLocalDataSource dataSource;

  @override
  Future<Result<List<Transaction>>> getTransactionHistory() async {
    try {
      final transactions = await dataSource.getTransactionHistory();
      return Success(transactions);
    } catch (e) {
      return Failure(
        'Error al cargar el historial de transacciones: ${e.toString()}',
      );
    }
  }

  @override
  Future<void> addTransaction(Transaction transaction) async {
    await dataSource.addTransaction(transaction);
  }
}
