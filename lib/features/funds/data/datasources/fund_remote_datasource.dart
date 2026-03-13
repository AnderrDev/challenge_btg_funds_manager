import 'package:btg_funds_manager/core/network/http_client.dart';
import 'package:btg_funds_manager/core/constants/app_constants.dart';
import 'package:btg_funds_manager/features/funds/data/models/fund_model.dart';

/// Remote data source interface for funds.
abstract class FundRemoteDataSource {
  Future<List<FundModel>> getFunds();
  Future<FundModel> getFundById(int id);
  Future<FundModel> subscribeTo(int fundId);
  Future<FundModel> cancelSubscription(int fundId);
  Future<double> getBalance();
  Future<void> updateBalance(double newBalance);
}

/// Remote data source implementation for funds — communicates with API via [HttpClient].
class FundRemoteDataSourceImpl implements FundRemoteDataSource {
  const FundRemoteDataSourceImpl({required this.client});

  final HttpClient client;

  @override
  Future<List<FundModel>> getFunds() async {
    final response = await client.get('${AppConstants.baseUrl}/funds');
    final List<dynamic> data = response.data as List<dynamic>;
    return data
        .map((json) => FundModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<FundModel> getFundById(int id) async {
    final response = await client.get('${AppConstants.baseUrl}/funds/$id');
    return FundModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<FundModel> subscribeTo(int fundId) async {
    final response = await client.patch(
      '${AppConstants.baseUrl}/funds/$fundId',
      data: {'isSubscribed': true},
    );
    return FundModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<FundModel> cancelSubscription(int fundId) async {
    final response = await client.patch(
      '${AppConstants.baseUrl}/funds/$fundId',
      data: {'isSubscribed': false},
    );
    return FundModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<double> getBalance() async {
    final response = await client.get('${AppConstants.baseUrl}/users/1');
    return (response.data['balance'] as num).toDouble();
  }

  @override
  Future<void> updateBalance(double newBalance) async {
    await client.patch(
      '${AppConstants.baseUrl}/users/1',
      data: {'balance': newBalance},
    );
  }
}
