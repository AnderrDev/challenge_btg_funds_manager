import 'package:dio/dio.dart';
import 'package:btg_funds_manager/core/constants/app_constants.dart';
import 'package:btg_funds_manager/features/funds/domain/entities/fund.dart';

/// Remote data source for funds — communicates with json-server via Dio.
class FundRemoteDataSource {
  const FundRemoteDataSource({required this.dio});

  final Dio dio;

  /// Fetches all funds from the API.
  Future<List<Fund>> getFunds() async {
    final response = await dio.get('${AppConstants.baseUrl}/funds');
    final List<dynamic> data = response.data as List<dynamic>;
    return data
        .map((json) => Fund.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Fetches a single fund by [id] from the API.
  Future<Fund> getFundById(int id) async {
    final response = await dio.get('${AppConstants.baseUrl}/funds/$id');
    return Fund.fromJson(response.data as Map<String, dynamic>);
  }

  /// Marks a fund as subscribed via PATCH.
  Future<Fund> subscribeTo(int fundId) async {
    final response = await dio.patch(
      '${AppConstants.baseUrl}/funds/$fundId',
      data: {'isSubscribed': true},
    );
    return Fund.fromJson(response.data as Map<String, dynamic>);
  }

  /// Marks a fund as unsubscribed via PATCH.
  Future<Fund> cancelSubscription(int fundId) async {
    final response = await dio.patch(
      '${AppConstants.baseUrl}/funds/$fundId',
      data: {'isSubscribed': false},
    );
    return Fund.fromJson(response.data as Map<String, dynamic>);
  }

  /// Returns current user balance from the API.
  Future<double> getBalance() async {
    final response = await dio.get('${AppConstants.baseUrl}/users/1');
    return (response.data['balance'] as num).toDouble();
  }

  /// Updates user balance via PATCH.
  Future<void> updateBalance(double newBalance) async {
    await dio.patch(
      '${AppConstants.baseUrl}/users/1',
      data: {'balance': newBalance},
    );
  }
}
