import '../domain.dart';

///[Fetch] abstract class recive the method named [call] it's
///the type FetchCallBack
abstract class Fetch {
  ///this method receive a [Request]
  FetchCallback call({required Request request});
}

///Creates the class [FetchImpl] implementing the [Fetch] abstract class.
///The async method [call] creates a either which receives
///the [repository] answer and
///returns the [left] and [right] results.
/// in case of right r, verifies if the r.status was validated
/// by [request.validateStatus.call]
/// in this case, returns [right] with the r response.
/// else, specify a variable error type [UnoError] with the error
/// status, request and response.
/// returns a [left] with the error

class FetchImpl implements Fetch {
  ///the class receives de [HttpRepository] responsible for realizing
  //////the fetch request and
  ///implements the method [call].
  final HttpRepository repository;

  ///[FetchImpl] constructor
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
