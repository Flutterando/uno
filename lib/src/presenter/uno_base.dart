import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:uno/src/domain/domain.dart';
import 'package:uno/src/inject_context.dart';
import 'package:characters/characters.dart';
import 'package:uno/src/presenter/interceptors.dart';

abstract class Uno {
  String get baseUrl;
  Duration get timeout;
  Map<String, String> get headers;
  Interceptors get interceptors;

  @visibleForTesting
  InjectContext get context;

  factory Uno({
    String baseUrl = '',
    Map<String, String> headers = const {},
    Duration timeout = const Duration(seconds: 30),
  }) =>
      _Uno(baseUrl: baseUrl, headers: headers, timeout: timeout);

  FutureOr<Response> call(
    String url, {
    String method = 'get',
    Map<String, String> params = const {},
    Map<String, String> headers = const {},
    ResponseType responseType = ResponseType.json,
    void Function(int total, int current)? onDownloadProgress,
    dynamic data,
  });

  FutureOr<Response> get(
    String url, {
    Map<String, String> params = const {},
    Map<String, String> headers = const {},
    ResponseType responseType = ResponseType.json,
    void Function(int total, int current)? onDownloadProgress,
  });

  FutureOr<Response> post(
    String url, {
    Map<String, String> params = const {},
    Map<String, String> headers = const {},
    ResponseType responseType = ResponseType.json,
    void Function(int total, int current)? onDownloadProgress,
    dynamic data,
  });

  FutureOr<Response> put(
    String url, {
    Map<String, String> params = const {},
    Map<String, String> headers = const {},
    ResponseType responseType = ResponseType.json,
    void Function(int total, int current)? onDownloadProgress,
    dynamic data,
  });

  FutureOr<Response> delete(
    String url, {
    Map<String, String> params = const {},
    Map<String, String> headers = const {},
    ResponseType responseType = ResponseType.json,
    void Function(int total, int current)? onDownloadProgress,
  });

  FutureOr<Response> patch(
    String url, {
    Map<String, String> params = const {},
    Map<String, String> headers = const {},
    ResponseType responseType = ResponseType.json,
    void Function(int total, int current)? onDownloadProgress,
    dynamic data,
  });

  FutureOr<Response> head(
    String url, {
    Map<String, String> params = const {},
    Map<String, String> headers = const {},
    ResponseType responseType = ResponseType.json,
    void Function(int total, int current)? onDownloadProgress,
  });

  FutureOr<Response> request(Request request);
}

class _Uno implements Uno {
  @override
  final Duration timeout;

  @override
  final String baseUrl;

  @override
  final Map<String, String> headers;

  @override
  late final InjectContext context;

  @override
  final interceptors = Interceptors();

  _Uno({
    required this.baseUrl,
    required this.headers,
    required this.timeout,
  }) : context = InjectContext.defaultConfig();

  @override
  FutureOr<Response> get(
    String url, {
    Map<String, String> params = const {},
    Map<String, String> headers = const {},
    ResponseType responseType = ResponseType.json,
    void Function(int total, int current)? onDownloadProgress,
  }) {
    return call(
      url,
      method: 'get',
      params: params,
      headers: headers,
      responseType: responseType,
      onDownloadProgress: onDownloadProgress,
    );
  }

  @override
  FutureOr<Response> delete(
    String url, {
    Map<String, String> params = const {},
    Map<String, String> headers = const {},
    ResponseType responseType = ResponseType.json,
    void Function(int total, int current)? onDownloadProgress,
  }) {
    return call(
      url,
      method: 'delete',
      params: params,
      headers: headers,
      responseType: responseType,
      onDownloadProgress: onDownloadProgress,
    );
  }

  @override
  FutureOr<Response> head(
    String url, {
    Map<String, String> params = const {},
    Map<String, String> headers = const {},
    ResponseType responseType = ResponseType.json,
    void Function(int total, int current)? onDownloadProgress,
  }) {
    return call(
      url,
      method: 'head',
      params: params,
      headers: headers,
      responseType: responseType,
      onDownloadProgress: onDownloadProgress,
    );
  }

  @override
  FutureOr<Response> patch(
    String url, {
    Map<String, String> params = const {},
    Map<String, String> headers = const {},
    ResponseType responseType = ResponseType.json,
    void Function(int total, int current)? onDownloadProgress,
    dynamic data,
  }) {
    return call(
      url,
      method: 'patch',
      params: params,
      headers: headers,
      data: data,
      responseType: responseType,
      onDownloadProgress: onDownloadProgress,
    );
  }

  @override
  FutureOr<Response> post(
    String url, {
    Map<String, String> params = const {},
    Map<String, String> headers = const {},
    ResponseType responseType = ResponseType.json,
    void Function(int total, int current)? onDownloadProgress,
    dynamic data,
  }) {
    return call(
      url,
      method: 'post',
      params: params,
      headers: headers,
      data: data,
      responseType: responseType,
      onDownloadProgress: onDownloadProgress,
    );
  }

  @override
  FutureOr<Response> put(
    String url, {
    Map<String, String> params = const {},
    Map<String, String> headers = const {},
    ResponseType responseType = ResponseType.json,
    void Function(int total, int current)? onDownloadProgress,
    dynamic data,
  }) {
    return call(
      url,
      method: 'put',
      params: params,
      headers: headers,
      data: data,
      responseType: responseType,
      onDownloadProgress: onDownloadProgress,
    );
  }

  @override
  FutureOr<Response> call(
    String url, {
    String method = 'get',
    Map<String, String> params = const {},
    Map<String, String> headers = const {},
    ResponseType responseType = ResponseType.json,
    void Function(int total, int current)? onDownloadProgress,
    dynamic data,
  }) async {
    url = '$baseUrl$url${_encodeParamsToQueries(params)}';

    final _headers = <String, String>{}
      ..addAll(this.headers)
      ..addAll(headers);

    final uri = Uri.parse(url);
    var myRequest = Request(
      timeout: timeout,
      uri: uri,
      headers: _headers,
      method: method,
      responseType: responseType,
      onDownloadProgress: onDownloadProgress,
    );

    if (data is FormData) {
      _headers.addAll(data.getHeaders());
      myRequest = myRequest.copyWith(bodyBytes: data.body, headers: _headers);
    }

    if (data is Map) {
      final json = jsonEncode(data);
      final bytes = utf8.encode(json);
      _headers.addAll({'content-length': '${bytes.length}'});
      myRequest = myRequest.copyWith(bodyBytes: bytes, headers: _headers);
    }

    if (data is String) {
      final bytes = utf8.encode(data);
      _headers.addAll({'content-length': '${bytes.length}'});
      myRequest = myRequest.copyWith(bodyBytes: bytes, headers: _headers);
    }

    return await request(myRequest);
  }

  @override
  FutureOr<Response> request(Request request) async {
    request = await interceptors.request.resolve(request);
    final fetch = context<Fetch>();
    var result = await fetch(request: request);

    return await result.fold((l) async {
      final resolved = await interceptors.response.resolveError(l);
      if (resolved is Response) {
        return resolved;
      }
      throw resolved;
    }, (r) async {
      return await interceptors.response.resolve(r);
    });
  }

  String _encodeParamsToQueries(Map<String, String> params) {
    if (params.isEmpty) {
      return '';
    }

    final buffer = StringBuffer('?');

    for (var key in params.keys) {
      buffer.write('$key=${params[key]}&');
    }

    var encoded = buffer.toString();
    return (encoded.characters.toList()..removeLast()).join();
  }
}
