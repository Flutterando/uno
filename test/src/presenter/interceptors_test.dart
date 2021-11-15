import 'package:test/test.dart';
import 'package:uno/src/presenter/interceptors.dart';

import '../../mocks/mocks.dart';

void main() {
  test('interceptors request', () async {
    var requestFn = 0;
    var errorFn = 0;

    final interceptors = Interceptors();
    final resolver = interceptors.request.use((request) {
      requestFn++;
      return request;
    }, onError: (error) {
      errorFn++;
      return error;
    });
    interceptors.request.use((request) {
      requestFn++;
      return request;
    });
    interceptors.request.use((request) {
      requestFn++;
      return request;
    });

    final requestMock = RequestMock();
    final errorMock = UnoErrorMock();

    var request = await interceptors.request.resolve(requestMock);

    var error = await interceptors.request.resolveError(errorMock);

    expect(request, requestMock);
    expect(error, errorMock);
    expect(requestFn, 3);
    expect(errorFn, 1);

    requestFn = 0;
    errorFn = 0;
    interceptors.request.eject(resolver);
    await interceptors.request.resolve(requestMock);
    expect(requestFn, 2);
    expect(errorFn, 0);
  });
}
