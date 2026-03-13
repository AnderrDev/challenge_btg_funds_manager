import 'package:btg_funds_manager/core/utils/result.dart';
import 'package:btg_funds_manager/features/transactions/domain/entities/transaction.dart';
import 'package:btg_funds_manager/features/funds/data/datasources/fund_local_datasource.dart';
import 'package:btg_funds_manager/features/funds/domain/entities/fund.dart';
import 'package:btg_funds_manager/features/funds/domain/repositories/fund_repository.dart';

/// Concrete implementation of [FundRepository].
///
/// Bridges the domain layer with the local data source.
/// Wraps data source calls in [Result] for functional error handling.
class FundRepositoryImpl implements FundRepository {
  const FundRepositoryImpl({required this.dataSource});

  final FundLocalDataSource dataSource;

  @override
  Future<Result<List<Fund>>> getFunds() async {
    try {
      final funds = await dataSource.getFunds();
      return Success(funds);
    } catch (e) {
      return Failure('Error al cargar los fondos: ${e.toString()}');
    }
  }

  @override
  Future<Result<Fund>> subscribeTo({
    required int fundId,
    required NotificationMethod method,
    required double currentBalance,
  }) async {
    try {
      final fund = await dataSource.subscribeTo(fundId);
      return Success(fund);
    } catch (e) {
      return Failure('Error al suscribirse al fondo: ${e.toString()}');
    }
  }

  @override
  Future<Result<Fund>> cancelSubscription({required int fundId}) async {
    try {
      final fund = await dataSource.cancelSubscription(fundId);
      return Success(fund);
    } catch (e) {
      return Failure('Error al cancelar la suscripción: ${e.toString()}');
    }
  }

  @override
  Future<double> getBalance() async => dataSource.getBalance();

  @override
  Future<void> updateBalance(double newBalance) async {
    dataSource.updateBalance(newBalance);
  }
}
