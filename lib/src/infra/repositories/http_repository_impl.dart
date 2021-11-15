import '../infra.dart';

class HttpRepositoryImpl extends HttpRepository {
  final HttpDatasource datasource;

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
