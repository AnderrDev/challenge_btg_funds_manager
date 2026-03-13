import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/funds/data/datasources/fund_local_cache.dart';
import '../../features/funds/data/datasources/fund_remote_datasource.dart';
import '../../features/funds/data/repositories/fund_repository_impl.dart';
import '../../features/funds/domain/repositories/fund_repository.dart';
import '../../features/funds/domain/use_cases/cancel_subscription.dart';
import '../../features/funds/domain/use_cases/get_fund_detail.dart';
import '../../features/funds/domain/use_cases/get_funds.dart';
import '../../features/funds/domain/use_cases/subscribe_to_fund.dart';
import '../../features/funds/presentation/bloc/fund_detail_bloc.dart';
import '../../features/funds/presentation/bloc/funds_bloc.dart';
import '../../features/transactions/data/datasources/transaction_local_cache.dart';
import '../../features/transactions/data/datasources/transaction_remote_datasource.dart';
import '../../features/transactions/data/repositories/transaction_repository_impl.dart';
import '../../features/transactions/domain/repositories/transaction_repository.dart';
import '../../features/transactions/domain/use_cases/get_transaction_history.dart';
import '../../features/transactions/presentation/bloc/transactions_bloc.dart';

/// Global service locator instance.
final sl = GetIt.instance;

/// Registers all dependencies in the service locator.
///
/// Follows the dependency rule: DataSources → Repositories → Use Cases → BLoCs.
/// Each layer only depends on abstractions from inner layers.
Future<void> initDependencies() async {
  // ── External ────────────────────────────────────────────────────
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => Dio());

  // ── Data Sources & Caches ───────────────────────────────────────
  sl.registerLazySingleton<FundRemoteDataSource>(
    () => FundRemoteDataSource(dio: sl()),
  );
  sl.registerLazySingleton<FundLocalCache>(
    () => FundLocalCache(prefs: sl()),
  );
  sl.registerLazySingleton<TransactionRemoteDataSource>(
    () => TransactionRemoteDataSource(dio: sl()),
  );
  sl.registerLazySingleton<TransactionLocalCache>(
    () => TransactionLocalCache(prefs: sl()),
  );

  // ── Repositories ────────────────────────────────────────────────
  sl.registerLazySingleton<FundRepository>(
    () => FundRepositoryImpl(
      remoteDataSource: sl(),
      localCache: sl(),
    ),
  );
  sl.registerLazySingleton<TransactionRepository>(
    () => TransactionRepositoryImpl(
      remoteDataSource: sl(),
      localCache: sl(),
    ),
  );

  // ── Use Cases ───────────────────────────────────────────────────
  sl.registerLazySingleton(() => GetFunds(repository: sl()));
  sl.registerLazySingleton(() => GetFundDetail(repository: sl()));
  sl.registerLazySingleton(() => SubscribeToFund(
        fundRepository: sl(),
        transactionRepository: sl(),
      ));
  sl.registerLazySingleton(() => CancelSubscription(
        fundRepository: sl(),
        transactionRepository: sl(),
      ));
  sl.registerLazySingleton(() => GetTransactionHistory(repository: sl()));

  // ── BLoCs ───────────────────────────────────────────────────────
  sl.registerFactory(() => FundDetailBloc(
        getFundDetail: sl(),
      ));
  sl.registerFactory(() => FundsBloc(
        getFunds: sl(),
        subscribeToFund: sl(),
        cancelSubscription: sl(),
      ));
  sl.registerFactory(() => TransactionsBloc(
        getTransactionHistory: sl(),
      ));
}
