import 'package:btg_funds_manager/core/utils/result.dart';
import 'package:btg_funds_manager/features/transactions/domain/entities/transaction.dart';
import 'package:btg_funds_manager/features/transactions/domain/repositories/transaction_repository.dart';
import 'package:btg_funds_manager/features/transactions/data/datasources/transaction_remote_datasource.dart';
import 'package:btg_funds_manager/features/transactions/data/datasources/transaction_local_cache.dart';

/// Concrete implementation of [TransactionRepository].
///
/// Remote-first strategy with local cache fallback.
class TransactionRepositoryImpl implements TransactionRepository {
  const TransactionRepositoryImpl({
    required this.remoteDataSource,
    required this.localCache,
  });

  final TransactionRemoteDataSource remoteDataSource;
  final TransactionLocalCache localCache;

  @override
  Future<Result<List<Transaction>>> getTransactionHistory() async {
    try {
      final transactions = await remoteDataSource.getTransactionHistory();
      // Update local cache on success
      await localCache.cacheTransactions(transactions);
      return Success(transactions);
    } catch (e) {
      // Fallback to cached data
      final cached = localCache.getCachedTransactions();
      if (cached.isNotEmpty) {
        return Success(cached);
      }
      return Failure(
        'Error al cargar el historial de transacciones: ${e.toString()}',
      );
    }
  }

  @override
  Future<void> addTransaction(Transaction transaction) async {
    await remoteDataSource.addTransaction(transaction);
  }
}
