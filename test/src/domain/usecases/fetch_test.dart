import 'package:test/test.dart';
import 'package:uno/src/core/types/either.dart';

import 'package:uno/src/domain/usecases/fetch.dart';

import '../../../mocks/mocks.dart';

void main() {
  late HttpRepositoryMock repository;
  late RequestMock request;
  late Fetch usecase;

  setUp(() {
    repository = HttpRepositoryMock();
    usecase = FetchImpl(repository);
    request = RequestMock();
  });

  test('should fetch returning a Reponse object', () async {
    when(() => repository.fetch(request: request)).thenAnswer((_) => right(ResponseMock()));

    final result = await usecase.call(request: request);
    expect(result.isRight, true);
  });
}
