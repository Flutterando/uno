import 'dart:convert';

import 'package:test/test.dart';
import 'package:uno/src/domain/domain.dart';
import 'package:uno/src/external/universal_http_client.dart';

import '../../mocks/mocks.dart';

void main() {
  late UniversalHttpClient universalHttpClient;
  late HttpClientMock httpClientMock;
  late HttpClientRequestMock httpClientRequest;
  late HttpClientResponseMock httpClientResponse;
  late HttpHeadersMock httpHeadersMock;
  setUp(() {
    httpHeadersMock = HttpHeadersMock();
    httpClientRequest = HttpClientRequestMock();
    httpClientResponse = HttpClientResponseMock();
    httpClientMock = HttpClientMock();
    universalHttpClient = UniversalHttpClient(httpClientMock);
  });
  test('universal http client consumer', () async {
    final uri = Uri.parse('google.com');
    final request = Request(uri: uri, method: 'get', headers: const {}, timeout: Duration(seconds: 30));
    when(() => httpHeadersMock.set('Content-Length', '0')).thenReturn(httpHeadersMock);
    when(() => httpClientRequest.headers).thenReturn(httpHeadersMock);
    when(() => httpClientRequest.close()).thenAnswer((_) async => httpClientResponse);
    when(() => httpClientMock.openUrl('get', uri)).thenAnswer((_) async => httpClientRequest);

    when(() => httpClientResponse.transform(utf8.decoder)).thenAnswer((_) => Stream<String>.value(stringJsonMock));
    when(() => httpClientResponse.statusCode).thenReturn(200);
    when(() => httpClientResponse.headers).thenReturn(httpHeadersMock);

    final response = await universalHttpClient.fetch(request);
    expect(response.data['userId'], 1);
    expect(response.data['completed'], false);
  });
}
