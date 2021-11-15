import 'dart:convert';

import '../infra/infra.dart';
import 'package:universal_io/io.dart';

class UniversalHttpClient implements HttpDatasource {
  final HttpClient client;

  const UniversalHttpClient(this.client);

  @override
  Future<Response> fetch(Request unoRequest) async {
    client.connectionTimeout = unoRequest.timeout;

    final request = await client.openUrl(unoRequest.method, unoRequest.uri);

    for (var key in unoRequest.headers.keys) {
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
          unoRequest.onDownloadProgress?.call(response.contentLength, totalbytes);
          sink.add(value);
        },
      ),
    );

    var data = await _convertResponseData(mainStream, unoRequest.responseType);

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
  }

  dynamic _convertResponseData(Stream<List<int>> mainStream, ResponseType responseType) async {
    if (responseType == ResponseType.json) {
      final buffer = StringBuffer();
      await for (var item in mainStream.transform(utf8.decoder)) {
        buffer.write(item);
      }
      return jsonDecode(buffer.toString());
    } else if (responseType == ResponseType.plain) {
      final buffer = StringBuffer();
      await for (var item in mainStream.transform(utf8.decoder)) {
        buffer.write(item);
      }
      return buffer.toString();
    } else if (responseType == ResponseType.arraybuffer) {
      var bytes = <int>[];
      await for (var b in mainStream) {
        bytes.addAll(b);
      }
      return bytes;
    } else if (responseType == ResponseType.stream) {
      return mainStream;
    }
  }
}
