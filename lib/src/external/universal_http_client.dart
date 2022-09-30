import 'dart:convert';

import 'package:universal_io/io.dart';

import '../infra/infra.dart';

///Created the class [UniversalHttpClient] that implements [HttpDatasource]
/// [UniversalHttpClient] implements the [fetch] method from [HttpDatasource]
class UniversalHttpClient implements HttpDatasource {
  ///An HTTP client for communicating with an HTTP server.
  ///Sends HTTP requests to an HTTP server and receives responses.
  ///Maintains state, including session cookies and other cookies, between
  ///multiple requests to the same server.
  final HttpClient client;

  ///The [UniversalHttpClient] constructor
  const UniversalHttpClient(this.client);

  /// [fetch] method receives as it's parameter the [Request][unoRequest]
  /// It sets the client.connectionTimeout value the timeout value
  /// received in unoRequest
  /// the request is created receiving the HTTP connection, receiving
  /// the parameters unoRequest.method and unoRequest.uri
  /// For each key in [unoRequest.headers.keys] it will set a header
  /// for the request,  receiving the parameters key
  /// and [unoRequest.headers[key]]
  /// a unoRequest.bodyBytes will be added into request
  /// the response value will be the value on the request when closed.
  /// the unoRequest.onDownloadProgress will be called.
  /// the data value will be the [_convertResponseData] return, which
  /// will be receiving the
  /// parameters mainStream, unoRequest.responseType and [unoRequest].
  /// the variable headers is a map of type <String, String>
  /// For each item in the headers, the key will be converted and
  /// concatenated using.
  /// The variable type [Response] unoResponse receives
  /// the variables [unoRequest],
  /// response.statusCode, data and headers
  /// returns unoResponse
  /// If a [SocketException] occurs, a throw will be called with the information
  /// about the occured error.

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

      final headers = <String, String>{};

      response.headers.forEach((key, values) {
        headers[key] = values.join(',');
      });
      if( headers.containsKey('Content-Type')) {
        switch(headers['Content-Type']) {
          case 'application/json':
            unoRequest.responseType = ResponseType.json;
            break;
          case 'text/plain':
            unoRequest.responseType = ResponseType.plain;
            break;
          default:
            unoRequest.responseType = ResponseType.plain;
            break;
        }
      }

      final data = await _convertResponseData(
        mainStream,
        unoRequest.responseType,
        unoRequest,
      );

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

  /// the [dynamic] method [_convertResponseData] receives as a parameter
  /// a [Stream<List<int>] mainStream
  /// a [ResponseType] responseType and a [Request] request
  /// Verifies if responseType is equal to [ResponseType.json]
  /// Opens a try/catch bloc, it will try store in the buffer a [StringBuffer] and
  /// for each item in [mainStream.transform(utf8.decoder)] will add the string
  /// representation of the object
  /// return the [buffer.toString()] converting it to json
  /// if a [FormatException] occurs, a throw will be called with the information
  /// about the occured error.
  /// else if the responseType is equal to [ResponseType.plain]
  /// Opens a try/catch bloc, it will try store in the buffer a [StringBuffer] and
  /// for each item in [mainStream.transform(utf8.decoder)]
  /// will add the string
  /// representation of the object
  /// return the [buffer.toString()]
  /// if a [FormatException] occurs, a throw will be called with the information
  /// about the occured error.
  /// else if the responseType is equal to [ResponseType.arraybuffer]
  /// the variable bytes will be an int [List]
  /// for each b in mainStream, a b will be added into the bytes list
  /// returns bytes
  /// else if responseType is equal to [ResponseType.stream]
  /// returns mainStream.
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
