import 'dart:convert';

import 'package:mocktail/mocktail.dart';
import 'package:universal_io/io.dart';
import 'package:uno/src/infra/infra.dart';

export 'package:mocktail/mocktail.dart';

class HttpRepositoryMock extends Mock implements HttpRepository {}

class RequestMock extends Mock implements Request {}

class ResponseMock extends Mock implements Response {}

class HttpClientMock extends Mock implements HttpClient {}

class HttpDatasourceMock extends Mock implements HttpDatasource {}

class HttpClientRequestMock extends Mock implements HttpClientRequest {}

class HttpClientResponseMock extends Mock implements HttpClientResponse {
  @override
  Stream<S> transform<S>(StreamTransformer<List<int>, S> streamTransformer) {
    return streamTransformer.bind(Stream.value(utf8.encode(stringJsonMock)));
  }
}

class HttpHeadersMock extends Mock implements HttpHeaders {
  @override
  void forEach(void Function(String name, List<String> values) action) {
    action('test', ['test']);
  }
}

class UnoErrorMock extends Mock implements UnoError {}

const stringJsonMock = '''
{
  "userId": 1,
  "id": 1,
  "title": "delectus aut autem",
  "completed": false
}
''';
