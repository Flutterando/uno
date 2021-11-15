import 'package:mocktail/mocktail.dart';
import 'package:universal_io/io.dart';
import 'package:uno/src/domain/domain.dart';

export 'package:mocktail/mocktail.dart';

class HttpRepositoryMock extends Mock implements HttpRepository {}

class RequestMock extends Mock implements Request {}

class ResponseMock extends Mock implements Response {}

class HttpClientMock extends Mock implements HttpClient {}

class HttpClientRequestMock extends Mock implements HttpClientRequest {}

class HttpClientResponseMock extends Mock implements HttpClientResponse {}

class HttpHeadersMock extends Mock implements HttpHeaders {
  @override
  void forEach(void Function(String name, List<String> values) action) {}
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
