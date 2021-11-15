import 'package:test/test.dart';
import 'package:uno/src/core/types/either.dart';

import 'package:uno/src/domain/usecases/fetch.dart';
import 'package:uno/uno.dart';

import '../../../mocks/mocks.dart';

void main() {
  late HttpRepositoryMock repository;
  late RequestMock request;
  late ResponseMock response;
  late Fetch usecase;

  setUp(() {
    repository = HttpRepositoryMock();
    usecase = FetchImpl(repository);
    request = RequestMock();
    response = ResponseMock();
  });

  test('should fetch returning a Reponse object', () async {
    when(() => request.validateStatus).thenReturn((status) => true);
    when(() => response.status).thenReturn(200);
    when(() => repository.fetch(request: request))
        .thenAnswer((_) => right(response));

    final result = await usecase.call(request: request);
    expect(result.isRight, true);
  });
  test('invalid status', () async {
    when(() => request.validateStatus).thenReturn((status) => false); // <<<
    when(() => response.status).thenReturn(500);
    when(() => repository.fetch(request: request))
        .thenAnswer((_) => right(response));

    final result = await usecase.call(request: request);
    expect(result.isLeft, true);

    final error = result.fold(id, id);
    expect(error, isA<UnoError>());
    error.toString();
  });
}
