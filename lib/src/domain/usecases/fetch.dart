import '../domain.dart';

abstract class Fetch {
  FetchCallback call({required Request request});
}

class FetchImpl implements Fetch {
  final HttpRepository repository;

  FetchImpl(this.repository);

  @override
  FetchCallback call({required Request request}) async {
    final either = await repository.fetch(request: request);
    return either.bind((r) {
      if (request.validateStatus.call(r.status)) {
        return right(r);
      }

      final error = UnoError(
        'Status ${r.status}',
        request: request,
        response: r,
      );
      return left(error);
    });
  }
}
