import 'package:test/test.dart';
import 'package:uno/src/infra/infra.dart';

import '../../../mocks/mocks.dart';

void main() {
  late HttpRepository repository;
  late HttpDatasource datasource;

  setUp(() {
    datasource = HttpDatasourceMock();
    repository = HttpRepositoryImpl(datasource);
  });

  test('should return response', () async {
    final request = RequestMock();
    when(() => datasource.fetch(request))
        .thenAnswer((_) async => ResponseMock());

    final result = await repository.fetch(request: request);
    expect(result.isRight, true);
  });

  test('should return UnoError when did datasource error', () async {
    final request = RequestMock();
    when(() => datasource.fetch(request)).thenThrow(UnoErrorMock());

    final result = await repository.fetch(request: request);
    expect(result.isLeft, true);
  });
}
