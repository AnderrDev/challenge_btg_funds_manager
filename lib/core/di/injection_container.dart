import 'package:get_it/get_it.dart';

import '../../features/funds/data/datasources/fund_local_datasource.dart';
import '../../features/funds/data/repositories/fund_repository_impl.dart';
import '../../features/funds/domain/repositories/fund_repository.dart';
import '../../features/funds/domain/use_cases/cancel_subscription.dart';
import '../../features/funds/domain/use_cases/get_funds.dart';
import '../../features/funds/domain/use_cases/subscribe_to_fund.dart';
import '../../features/funds/presentation/bloc/funds_bloc.dart';
import '../../features/transactions/data/datasources/transaction_local_datasource.dart';
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
void initDependencies() {
  // ── Data Sources ────────────────────────────────────────────────
  sl.registerLazySingleton<FundLocalDataSource>(
    () => FundLocalDataSource(),
  );
  sl.registerLazySingleton<TransactionLocalDataSource>(
    () => TransactionLocalDataSource(),
  );

  // ── Repositories ────────────────────────────────────────────────
  sl.registerLazySingleton<FundRepository>(
    () => FundRepositoryImpl(dataSource: sl()),
  );
  sl.registerLazySingleton<TransactionRepository>(
    () => TransactionRepositoryImpl(dataSource: sl()),
  );

  // ── Use Cases ───────────────────────────────────────────────────
  sl.registerLazySingleton(() => GetFunds(repository: sl()));
  sl.registerLazySingleton(() => SubscribeToFund(
        fundRepository: sl(),
        transactionDataSource: sl(),
      ));
  sl.registerLazySingleton(() => CancelSubscription(
        fundRepository: sl(),
        transactionDataSource: sl(),
      ));
  sl.registerLazySingleton(() => GetTransactionHistory(repository: sl()));

  // ── BLoCs ───────────────────────────────────────────────────────
  sl.registerFactory(() => FundsBloc(
        getFunds: sl(),
        subscribeToFund: sl(),
        cancelSubscription: sl(),
      ));
  sl.registerFactory(() => TransactionsBloc(
        getTransactionHistory: sl(),
      ));
}
