import '../domain.dart';

abstract class Fetch {
  FetchCallback call({required Request request});
}

class FetchImpl implements Fetch {
  final HttpRepository repository;

  FetchImpl(this.repository);

  @override
  FetchCallback call({required Request request}) async {
    return await repository.fetch(request: request);
  }
}
