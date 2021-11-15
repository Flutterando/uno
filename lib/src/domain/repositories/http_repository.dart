import '../domain.dart';

abstract class HttpRepository {
  FetchCallback fetch({required Request request});
}
