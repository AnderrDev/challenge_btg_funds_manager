import 'package:btg_funds_manager/core/utils/result.dart';
import 'package:btg_funds_manager/features/funds/domain/entities/fund.dart';
import 'package:btg_funds_manager/features/funds/domain/repositories/fund_repository.dart';

/// Use case: retrieves all available funds.
///
/// Pure function wrapper — no side effects, delegates to repository.
class GetFunds {
  const GetFunds({required this.repository});

  final FundRepository repository;

  /// Executes the use case.
  Future<Result<List<Fund>>> call() => repository.getFunds();
}
