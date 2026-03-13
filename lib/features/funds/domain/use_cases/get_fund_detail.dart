import 'package:btg_funds_manager/core/utils/result.dart';
import 'package:btg_funds_manager/features/funds/domain/entities/fund.dart';
import 'package:btg_funds_manager/features/funds/domain/repositories/fund_repository.dart';

/// Use case: retrieves a single fund by its ID.
class GetFundDetail {
  const GetFundDetail({required this.repository});

  final FundRepository repository;

  /// Executes the use case.
  Future<Result<Fund>> call(int id) => repository.getFundById(id);
}
