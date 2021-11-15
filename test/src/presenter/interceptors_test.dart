import 'package:test/test.dart';
import 'package:uno/src/presenter/interceptors.dart';

import '../../mocks/mocks.dart';

void main() {
  test('interceptors request', () async {
    var requestFn = 0;

    final interceptors = Interceptors();
    interceptors.request.use((request) {
      requestFn++;
      return request;
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

    var request = await interceptors.request.resolve(requestMock);

    expect(request, requestMock);
    expect(requestFn, 3);
  });
}
