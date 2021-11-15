import '../infra.dart';

abstract class HttpDatasource {
  Future<Response> fetch(Request request);
}
