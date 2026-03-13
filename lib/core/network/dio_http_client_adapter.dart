import 'package:dio/dio.dart';
import 'http_client.dart';

/// Implementation of [HttpClient] using the Dio package.
class DioHttpClientAdapter implements HttpClient {
  const DioHttpClientAdapter({required this.dio});

  final Dio dio;

  @override
  Future<HttpResponse> get(
    String url, {
    Map<String, dynamic>? queryParameters,
  }) async {
    final response = await dio.get(url, queryParameters: queryParameters);
    return HttpResponse(
      data: response.data,
      statusCode: response.statusCode,
    );
  }

  @override
  Future<HttpResponse> post(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    final response = await dio.post(
      url,
      data: data,
      queryParameters: queryParameters,
    );
    return HttpResponse(
      data: response.data,
      statusCode: response.statusCode,
    );
  }

  @override
  Future<HttpResponse> patch(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    final response = await dio.patch(
      url,
      data: data,
      queryParameters: queryParameters,
    );
    return HttpResponse(
      data: response.data,
      statusCode: response.statusCode,
    );
  }

  @override
  Future<HttpResponse> delete(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    final response = await dio.delete(
      url,
      data: data,
      queryParameters: queryParameters,
    );
    return HttpResponse(
      data: response.data,
      statusCode: response.statusCode,
    );
  }
}
