import '../infra.dart';

///The class [HttpRepositoryImpl] that extends [HttpRepository]
///and receives a method called [fetch]
class HttpRepositoryImpl extends HttpRepository {
  ///The variable [datasource] it's the type [HttpDatasource]
  final HttpDatasource datasource;

  ///[HttpRepositoryImpl] constructor class
  HttpRepositoryImpl(this.datasource);

  @override
  FetchCallback fetch({required Request request}) async {
    try {
      final response = await datasource.fetch(request);
      return right(response);
    } on UnoError catch (e) {
      return left(e);
    }
  }
}
