/// Custom HTTP response wrapper to decouple from specific libraries.
class HttpResponse {
  const HttpResponse({
    required this.data,
    required this.statusCode,
  });

  final dynamic data;
  final int? statusCode;
}

/// Abstract interface for HTTP operations.
/// 
/// Following DIP and Adapter pattern to isolate network dependency.
abstract class HttpClient {
  Future<HttpResponse> get(
    String url, {
    Map<String, dynamic>? queryParameters,
  });

  Future<HttpResponse> post(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  });

  Future<HttpResponse> patch(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  });

  Future<HttpResponse> delete(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  });
}
