import '../domain.dart';

///[HttpRepository] abstract class that receive the method
///called [fetch]
abstract class HttpRepository {
  ///The method [fetch] receive by parameter [request] it's the type [Request]
  FetchCallback fetch({required Request request});
}
