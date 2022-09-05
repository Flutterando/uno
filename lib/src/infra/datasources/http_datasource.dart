import '../infra.dart';

///[HttpDatasource] abstract class with a method named [fetch]
abstract class HttpDatasource {
  ///The method named [fetch] has a return of type Future<Response> and recive
  ///param [request] of type [Request].
  Future<Response> fetch(Request request);
}
