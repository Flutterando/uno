import 'dart:convert';

import 'package:test/test.dart';
import 'package:universal_io/io.dart';
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

  group('All request types', () {
    test('universal http client consumer (JSON)', () async {
      final uri = Uri.parse('google.com');
      final request = Request(
        uri: uri,
        method: 'get',
        headers: const {'test': 'test'},
        timeout: const Duration(seconds: 30),
      );
      when(() => httpHeadersMock.set('test', 'test')).thenReturn(
        // ignore: void_checks
        true,
      );
      when(() => httpClientRequest.headers).thenReturn(httpHeadersMock);
      when(() => httpClientRequest.close()).thenAnswer(
        (_) async => httpClientResponse,
      );
      when(() => httpClientMock.openUrl('get', uri)).thenAnswer(
        (_) async => httpClientRequest,
      );

      when(() => httpClientResponse.statusCode).thenReturn(200);
      when(() => httpClientResponse.headers).thenReturn(httpHeadersMock);

      final response = await universalHttpClient.fetch(request);
      expect(response.data['userId'], 1);
      expect(response.data['completed'], false);
    });
    test('universal http client consumer (PLAIN)', () async {
      final uri = Uri.parse('google.com');
      final request = Request(
        uri: uri,
        method: 'get',
        headers: const {},
        timeout: const Duration(seconds: 30),
        responseType: ResponseType.plain,
      );
      when(() => httpClientRequest.close()).thenAnswer(
        (_) async => httpClientResponse,
      );
      when(() => httpClientMock.openUrl('get', uri)).thenAnswer(
        (_) async => httpClientRequest,
      );

      when(() => httpClientResponse.statusCode).thenReturn(200);
      when(() => httpClientResponse.headers).thenReturn(httpHeadersMock);

      final response = await universalHttpClient.fetch(request);
      expect(response.data, stringJsonMock);
    });
    test('universal http client consumer (ARRAYBUFFER)', () async {
      final uri = Uri.parse('google.com');
      final request = Request(
        uri: uri,
        method: 'get',
        headers: const {},
        timeout: const Duration(seconds: 30),
        responseType: ResponseType.arraybuffer,
      );
      when(() => httpClientRequest.close()).thenAnswer(
        (_) async => httpClientResponse,
      );
      when(() => httpClientMock.openUrl('get', uri)).thenAnswer(
        (_) async => httpClientRequest,
      );

      when(() => httpClientResponse.statusCode).thenReturn(200);
      when(() => httpClientResponse.headers).thenReturn(httpHeadersMock);

      final response = await universalHttpClient.fetch(request);
      expect(utf8.decode(response.data), stringJsonMock);
    });
    test('universal http client consumer (STREAM)', () async {
      final uri = Uri.parse('google.com');
      final request = Request(
        uri: uri,
        method: 'get',
        headers: const {},
        timeout: const Duration(seconds: 30),
        responseType: ResponseType.stream,
      );
      when(() => httpClientRequest.close()).thenAnswer(
        (_) async => httpClientResponse,
      );
      when(() => httpClientMock.openUrl('get', uri)).thenAnswer(
        (_) async => httpClientRequest,
      );

      when(() => httpClientResponse.statusCode).thenReturn(200);
      when(() => httpClientResponse.headers).thenReturn(httpHeadersMock);

      final response = await universalHttpClient.fetch(request);
      final buffer = await (response.data as Stream<List<int>>).reduce(
        (previous, newValue) => previous..addAll(newValue),
      );
      request.toString();
      expect(utf8.decode(buffer), stringJsonMock);
    });
  });

  test('SocketException: connection refused', () {
    final uri = Uri.parse('google.com');
    final request = Request(
      uri: uri,
      method: 'get',
      headers: const {},
      timeout: const Duration(seconds: 30),
      responseType: ResponseType.stream,
    );

    when(() => httpClientMock.openUrl('get', uri)).thenThrow(
      const SocketException.closed(),
    );

    expect(
      () async => universalHttpClient.fetch(request),
      throwsA(isA<UnoError>()),
    );
  });
}
