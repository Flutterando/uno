import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:uno/src/domain/domain.dart';
import 'package:uno/src/inject_context.dart';
import 'package:characters/characters.dart';

part 'interceptors.dart';

abstract class Uno {
  String get baseURL;
  Duration get timeout;
  Map<String, String> get headers;
  Interceptors get interceptors;

  @visibleForTesting
  InjectContext get context;

  factory Uno({
    String baseURL = '',
    Map<String, String> headers = const {},
    Duration timeout = const Duration(seconds: 30),
  }) =>
      _Uno(baseURL: baseURL, headers: headers, timeout: timeout);

  Future<Response> call({
    required String url,
    String method = 'get',
    Map<String, String> params = const {},
    Map<String, String> headers = const {},
    ResponseType responseType = ResponseType.json,
    void Function(int total, int current)? onDownloadProgress,
    dynamic data,
  });

  Future<Response> get(
    String url, {
    Map<String, String> params = const {},
    Map<String, String> headers = const {},
    ResponseType responseType = ResponseType.json,
    void Function(int total, int current)? onDownloadProgress,
  });

  Future<Response> post(
    String url, {
    Map<String, String> params = const {},
    Map<String, String> headers = const {},
    ResponseType responseType = ResponseType.json,
    void Function(int total, int current)? onDownloadProgress,
    dynamic data,
  });

  Future<Response> put(
    String url, {
    Map<String, String> params = const {},
    Map<String, String> headers = const {},
    ResponseType responseType = ResponseType.json,
    void Function(int total, int current)? onDownloadProgress,
    dynamic data,
  });

  Future<Response> delete(
    String url, {
    Map<String, String> params = const {},
    Map<String, String> headers = const {},
    ResponseType responseType = ResponseType.json,
    void Function(int total, int current)? onDownloadProgress,
  });

  Future<Response> patch(
    String url, {
    Map<String, String> params = const {},
    Map<String, String> headers = const {},
    ResponseType responseType = ResponseType.json,
    void Function(int total, int current)? onDownloadProgress,
    dynamic data,
  });

  Future<Response> head(
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
  final String baseURL;

  @override
  final Map<String, String> headers;

  @override
  late final InjectContext context;

  @override
  final interceptors = Interceptors();

  _Uno({
    required this.baseURL,
    required this.headers,
    required this.timeout,
  }) : context = InjectContext.defaultConfig();

  @override
  Future<Response> get(
    String url, {
    Map<String, String> params = const {},
    Map<String, String> headers = const {},
    ResponseType responseType = ResponseType.json,
    void Function(int total, int current)? onDownloadProgress,
  }) {
    return call(
      url: url,
      method: 'get',
      params: params,
      headers: headers,
      responseType: responseType,
      onDownloadProgress: onDownloadProgress,
    );
  }

  @override
  Future<Response> delete(
    String url, {
    Map<String, String> params = const {},
    Map<String, String> headers = const {},
    ResponseType responseType = ResponseType.json,
    void Function(int total, int current)? onDownloadProgress,
  }) {
    return call(
      url: url,
      method: 'delete',
      params: params,
      headers: headers,
      responseType: responseType,
      onDownloadProgress: onDownloadProgress,
    );
  }

  @override
  Future<Response> head(
    String url, {
    Map<String, String> params = const {},
    Map<String, String> headers = const {},
    ResponseType responseType = ResponseType.json,
    void Function(int total, int current)? onDownloadProgress,
  }) {
    return call(
      url: url,
      method: 'head',
      params: params,
      headers: headers,
      responseType: responseType,
      onDownloadProgress: onDownloadProgress,
    );
  }

  @override
  Future<Response> patch(
    String url, {
    Map<String, String> params = const {},
    Map<String, String> headers = const {},
    ResponseType responseType = ResponseType.json,
    void Function(int total, int current)? onDownloadProgress,
    dynamic data,
  }) {
    return call(
      url: url,
      method: 'patch',
      params: params,
      headers: headers,
      data: data,
      responseType: responseType,
      onDownloadProgress: onDownloadProgress,
    );
  }

  @override
  Future<Response> post(
    String url, {
    Map<String, String> params = const {},
    Map<String, String> headers = const {},
    ResponseType responseType = ResponseType.json,
    void Function(int total, int current)? onDownloadProgress,
    dynamic data,
  }) {
    return call(
      url: url,
      method: 'post',
      params: params,
      headers: headers,
      data: data,
      responseType: responseType,
      onDownloadProgress: onDownloadProgress,
    );
  }

  @override
  Future<Response> put(
    String url, {
    Map<String, String> params = const {},
    Map<String, String> headers = const {},
    ResponseType responseType = ResponseType.json,
    void Function(int total, int current)? onDownloadProgress,
    dynamic data,
  }) {
    return call(
      url: url,
      method: 'put',
      params: params,
      headers: headers,
      data: data,
      responseType: responseType,
      onDownloadProgress: onDownloadProgress,
    );
  }

  @override
  Future<Response> call({
    required String url,
    String method = 'get',
    Map<String, String> params = const {},
    Map<String, String> headers = const {},
    ResponseType responseType = ResponseType.json,
    void Function(int total, int current)? onDownloadProgress,
    dynamic data,
  }) async {
    url = '$baseURL$url${_encodeParamsToQueries(params)}';

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
    request = await interceptors.request._resolve(request);
    final fetch = context<Fetch>();
    var result = await fetch(request: request);

    return await result.fold((l) async {
      final resolved = await interceptors.response._resolveError(l);
      if (resolved is Response) {
        return resolved;
      }
      throw resolved;
    }, (r) async {
      return await interceptors.response._resolve(r);
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
