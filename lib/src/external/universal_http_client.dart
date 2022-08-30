import 'dart:convert';

import 'package:universal_io/io.dart';

import '../infra/infra.dart';

class UniversalHttpClient implements HttpDatasource {
  final HttpClient client;

  const UniversalHttpClient(this.client);

  @override
  Future<Response> fetch(Request unoRequest) async {
    client.connectionTimeout = unoRequest.timeout;
    try {
      final request = await client.openUrl(unoRequest.method, unoRequest.uri);

      for (final key in unoRequest.headers.keys) {
        request.headers.set(key, unoRequest.headers[key]!);
      }

      request.add(unoRequest.bodyBytes);
      final response = await request.close();

      unoRequest.onDownloadProgress?.call(response.contentLength, 0);
      var totalbytes = 0;
      final mainStream = response.transform<List<int>>(
        StreamTransformer.fromHandlers(
          handleData: (value, sink) {
            totalbytes += value.length;
            unoRequest.onDownloadProgress?.call(
              response.contentLength,
              totalbytes,
            );
            sink.add(value);
          },
        ),
      );

      final data = await _convertResponseData(
        mainStream,
        unoRequest.responseType,
        unoRequest,
      );

      final headers = <String, String>{};

      response.headers.forEach((key, values) {
        headers[key] = values.join(',');
      });

      final unoResponse = Response(
        request: unoRequest,
        status: response.statusCode,
        data: data,
        headers: headers,
      );
      return unoResponse;
    } on SocketException catch (e, s) {
      throw UnoError<SocketException>(
        e.toString().replaceFirst('SocketException', ''),
        stackTrace: s,
        request: unoRequest,
        data: e,
      );
    }
  }

  dynamic _convertResponseData(
    Stream<List<int>> mainStream,
    ResponseType responseType,
    Request request,
  ) async {
    if (responseType == ResponseType.json) {
      try {
        final buffer = StringBuffer();
        await for (final item in mainStream.transform(utf8.decoder)) {
          buffer.write(item);
        }

        return jsonDecode(buffer.toString());
      } on FormatException catch (e, s) {
        throw UnoError<FormatException>(
          '''Data body isn`t a json. Please, use other [ResponseType] in request.''',
          data: e,
          request: request,
          stackTrace: s,
        );
      }
    } else if (responseType == ResponseType.plain) {
      try {
        final buffer = StringBuffer();
        await for (final item in mainStream.transform(utf8.decoder)) {
          buffer.write(item);
        }
        return buffer.toString();
      } on FormatException catch (e, s) {
        throw UnoError<FormatException>(
          '''Data body isn`t a plain text (String). Please, use other [ResponseType] in request.''',
          data: e,
          request: request,
          stackTrace: s,
        );
      }
    } else if (responseType == ResponseType.arraybuffer) {
      final bytes = <int>[];
      await for (final b in mainStream) {
        bytes.addAll(b);
      }
      return bytes;
    } else if (responseType == ResponseType.stream) {
      return mainStream;
    }
  }
}
