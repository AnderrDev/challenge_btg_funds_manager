import 'package:dio/dio.dart';
import 'package:btg_funds_manager/core/constants/app_constants.dart';
import 'package:btg_funds_manager/features/transactions/domain/entities/transaction.dart';

/// Remote data source for transactions — communicates with json-server via Dio.
class TransactionRemoteDataSource {
  const TransactionRemoteDataSource({required this.dio});

  final Dio dio;

  /// Fetches all transactions sorted by date descending.
  Future<List<Transaction>> getTransactionHistory() async {
    final response = await dio.get(
      '${AppConstants.baseUrl}/transactions',
      queryParameters: {'_sort': 'date', '_order': 'desc'},
    );
    final List<dynamic> data = response.data as List<dynamic>;
    return data
        .map((json) => Transaction.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Posts a new transaction to the API.
  Future<void> addTransaction(Transaction transaction) async {
    await dio.post(
      '${AppConstants.baseUrl}/transactions',
      data: transaction.toJson(),
    );
  }
}
