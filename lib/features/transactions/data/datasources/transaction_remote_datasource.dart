import 'package:btg_funds_manager/core/network/http_client.dart';
import 'package:btg_funds_manager/core/constants/app_constants.dart';
import 'package:btg_funds_manager/features/transactions/data/models/transaction_model.dart';

/// Remote data source interface for transactions.
abstract class TransactionRemoteDataSource {
  Future<List<TransactionModel>> getTransactionHistory();
  Future<void> addTransaction(TransactionModel transaction);
}

/// Remote data source implementation for transactions — communicates with API via [HttpClient].
class TransactionRemoteDataSourceImpl implements TransactionRemoteDataSource {
  const TransactionRemoteDataSourceImpl({required this.client});

  final HttpClient client;

  @override
  Future<List<TransactionModel>> getTransactionHistory() async {
    final response = await client.get(
      '${AppConstants.baseUrl}/transactions',
      queryParameters: {'_sort': 'date', '_order': 'desc'},
    );
    final List<dynamic> data = response.data as List<dynamic>;
    return data
        .map((json) => TransactionModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> addTransaction(TransactionModel transaction) async {
    await client.post(
      '${AppConstants.baseUrl}/transactions',
      data: transaction.toJson(),
    );
  }
}
