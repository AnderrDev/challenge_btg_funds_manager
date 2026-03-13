import 'package:btg_funds_manager/core/utils/result.dart';
import 'package:btg_funds_manager/features/transactions/domain/entities/transaction.dart';
import 'package:btg_funds_manager/features/funds/data/datasources/fund_remote_datasource.dart';
import 'package:btg_funds_manager/features/funds/data/datasources/fund_local_cache.dart';
import 'package:btg_funds_manager/features/funds/domain/entities/fund.dart';
import 'package:btg_funds_manager/features/funds/domain/repositories/fund_repository.dart';

/// Concrete implementation of [FundRepository].
///
/// Uses a remote-first strategy with local cache fallback:
/// 1. Try to fetch from json-server API (via Dio)
/// 2. On success, update SharedPreferences cache
/// 3. On failure, serve data from local cache
class FundRepositoryImpl implements FundRepository {
  const FundRepositoryImpl({
    required this.remoteDataSource,
    required this.localCache,
  });

  final FundRemoteDataSource remoteDataSource;
  final FundLocalCache localCache;

  @override
  Future<Result<List<Fund>>> getFunds() async {
    try {
      final funds = await remoteDataSource.getFunds();
      // Update local cache on success
      await localCache.cacheFunds(funds);
      return Success(funds);
    } catch (e) {
      // Fallback to cached data
      final cachedFunds = localCache.getCachedFunds();
      if (cachedFunds.isNotEmpty) {
        return Success(cachedFunds);
      }
      return Failure('Error al cargar los fondos: ${e.toString()}');
    }
  }

  @override
  Future<Result<Fund>> getFundById(int id) async {
    try {
      final fund = await remoteDataSource.getFundById(id);
      return Success(fund);
    } catch (e) {
      // Fallback to cached data
      final cachedFund = localCache.getCachedFundById(id);
      if (cachedFund != null) {
        return Success(cachedFund);
      }
      return Failure('Error al cargar el fondo: ${e.toString()}');
    }
  }

  @override
  Future<Result<Fund>> subscribeTo({
    required int fundId,
    required NotificationMethod method,
    required double currentBalance,
  }) async {
    try {
      final fund = await remoteDataSource.subscribeTo(fundId);
      return Success(fund);
    } catch (e) {
      return Failure('Error al suscribirse al fondo: ${e.toString()}');
    }
  }

  @override
  Future<Result<Fund>> cancelSubscription({required int fundId}) async {
    try {
      final fund = await remoteDataSource.cancelSubscription(fundId);
      return Success(fund);
    } catch (e) {
      return Failure('Error al cancelar la suscripción: ${e.toString()}');
    }
  }

  @override
  Future<double> getBalance() async {
    try {
      final balance = await remoteDataSource.getBalance();
      await localCache.cacheBalance(balance);
      return balance;
    } catch (_) {
      return localCache.getCachedBalance() ?? 0.0;
    }
  }

  @override
  Future<void> updateBalance(double newBalance) async {
    try {
      await remoteDataSource.updateBalance(newBalance);
      await localCache.cacheBalance(newBalance);
    } catch (e) {
      // Still cache locally but log the actual error for debugging
      print('DEBUG: Error updating balance on server: $e');
      await localCache.cacheBalance(newBalance);
    }
  }
}
