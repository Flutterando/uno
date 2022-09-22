import 'package:test/test.dart';
import 'package:uno/src/presenter/uno_base.dart';

import '../../mocks/mocks.dart';

void main() {
  test('interceptors request', () async {
    var requestFn = 0;
    var errorFn = 0;

    final interceptors = Interceptors();
    final resolver = interceptors.request.use(
      (request) {
        requestFn++;
        return request;
      },
      onError: (error) {
        errorFn++;
        return error;
      },
    );
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

    final request = await interceptors.request.resolveTest(requestMock);

    final error = await interceptors.request.resolveErrorTest(errorMock);

    expect(request, requestMock);
    expect(error, errorMock);
    expect(requestFn, 3);
    expect(errorFn, 1);

    requestFn = 0;
    errorFn = 0;
    interceptors.request.eject(resolver);
    await interceptors.request.resolveTest(requestMock);
    expect(requestFn, 2);
    expect(errorFn, 0);
  });
}
