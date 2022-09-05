import '../domain.dart';

/// Represents the response from the HTTP server.
class Response {
  /// Represents the request that will be sent to the http server.
  final Request request;

  /// status code coming from the server. ex: [200], [401], [404], [500]...
  final int status;

  /// Response body.
  /// The data type is defined in [Request.responseType].
  final dynamic data;

  /// Headers of response.
  final Map<String, String> headers;

  ///[Response] constructor class
  const Response({
    required this.headers,
    required this.request,
    required this.status,
    required this.data,
  });
}
