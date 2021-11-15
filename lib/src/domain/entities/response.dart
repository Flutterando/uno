import '../domain.dart';

class Response {
  final Request request;
  final int status;
  final dynamic data;
  final Map<String, String> headers;

  const Response({required this.headers, required this.request, required this.status, required this.data});
}
