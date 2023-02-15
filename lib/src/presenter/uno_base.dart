// ignore_for_file: parameter_assignments

import 'dart:convert';

import 'package:characters/characters.dart';
import 'package:meta/meta.dart';
import 'package:universal_io/io.dart';
import 'package:uno/src/domain/domain.dart';
import 'package:uno/src/inject_context.dart';

part 'interceptors.dart';

///[DownloadCallback] it's a typedef of void Function(int total, int current)
typedef DownloadCallback = void Function(int total, int current);

/// This is a Http Client inspired by AxiosJS.
abstract class Uno {
  /// `baseURL` will be prepended to `url` unless `url` is absolute.
  /// It can be convenient to set `baseURL` for an instance of uno to
  /// pass relative URLs
  /// to methods of that instance.
  String get baseURL;

  /// Default request timeout
  /// Time that the server will wait for the response to the request.
  /// The connection will be interrupted if you hear timeout.
  Duration get timeout;

  /// Default headers for all requests.
  Map<String, String> get headers;

  /// Create or remove interceptors for [Request] and [Response].
  /// ```dart
  /// uno.interceptors.request.use((request) {
  ///   return request;
  /// }, onError: (error) {
  ///   return error;
  /// });
  ///
  /// // or
  ///
  /// uno.interceptors.response.use((response) {
  ///   return response;
  /// }, onError: (error) {
  ///   return error;
  /// });
  /// ```
  Interceptors get interceptors;

  @visibleForTesting

  ///The get [context] it's the type [InjectContext]
  InjectContext get context;

  /// Creating an instance of Uno with new global options
  factory Uno({
    String baseURL = '',
    Map<String, String> headers = const {},
    Duration timeout = const Duration(seconds: 30),
  }) =>
      _Uno(baseURL: baseURL, headers: headers, timeout: timeout);

  /// Creates request with uno API:
  ///
  /// ```dart
  ///  uno(
  ///   method: 'post',
  ///   url: '/user/12345',
  ///   timeout: Duration(second: 15),
  ///   responseType: ResponseType.json,
  ///   data: {
  ///     firstName: 'Fred',
  ///     lastName: 'Flintstone'
  ///   },
  /// );
  /// ```
  Future<Response> call({
    /// [required] Url of request
    required String url,

    /// Time that the server will wait for the response to the request.
    /// The connection will be interrupted if you hear timeout.
    Duration? timeout,

    /// Represents the request method.
    /// ex: [GET, POST, PUT, DELETE, PATCH, HEAD].
    /// default is [get].
    String method = 'get',

    /// Adds query params.
    /// Must be a plain object or a URLSearchParams object.;
    /// exe:
    ///```dart
    /// uno.get('/users',params: {
    ///   'id': '1',
    /// });
    /// ```
    /// This generate ['/users?id=1'];
    Map<String, String> params = const {},

    /// Headers of request.
    Map<String, String> headers = const {},

    /// Represents the [Response] data type.
    /// Could use:
    /// ```dart
    /// ResponseType.json //default
    /// ResponseType.plain
    /// ResponseType.arraybuffer
    /// ResponseType.stream
    /// ```
    ResponseType responseType = ResponseType.json,

    /// Callback from API to client about request`s upload.
    /// ```dart
    ///  uno(
    ///  method: 'get',
    ///  url: 'http://bit.ly/2mTM3nY',
    ///  // you can use plain, json(default), arraybuffer and stream;
    ///  responseType: ResponseType.arraybuffer,
    ///  onDownloadProgress: (total, current) {
    ///    final percentCompleted = (current / total * 100).round();
    ///    print('completed: $percentCompleted%');
    ///  },
    /// ).then((response) async {
    ///   await File('ada_lovelace.jpg').writeAsBytes(response.data);
    /// });
    /// ```
    DownloadCallback? onDownloadProgress,

    /// Using the validateStatus config option,
    /// you can define HTTP code(s) that should throw an error.
    /// ```dart
    /// axios.get('/user/12345', {
    ///   validateStatus: (status) {
    ///     return status < 500; // Resolve only if the status code is less than 500
    ///   }
    /// });
    /// ```
    ValidateCallback? validateStatus,

    /// `data` is the data to be sent as the request body
    /// Only applicable for request methods 'PUT', 'POST', 'DELETE , and 'PATCH'
    /// - String, Map(json) or FormData
    dynamic data,
  });

  /// Aliase to `GET` method.
  Future<Response> get(
    String url, {
    /// Time that the server will wait for the response to the request.
    /// The connection will be interrupted if you hear timeout.
    Duration? timeout,

    /// Adds query params.
    /// Must be a plain object or a URLSearchParams object.;
    /// exe:
    ///```dart
    /// uno.get('/users',params: {
    ///   'id': '1',
    /// });
    /// ```
    /// This generate ['/users?id=1'];
    Map<String, String> params = const {},

    /// Headers of request.
    Map<String, String> headers = const {},

    /// Represents the [Response] data type.
    /// Could use:
    /// ```dart
    /// ResponseType.json //default
    /// ResponseType.plain
    /// ResponseType.arraybuffer
    /// ResponseType.stream
    /// ```
    ResponseType responseType = ResponseType.json,

    /// Callback from API to client about request`s upload.
    /// ```dart
    ///  uno(
    ///  method: 'get',
    ///  url: 'http://bit.ly/2mTM3nY',
    ///  // you can use plain, json(default), arraybuffer and stream;
    ///  responseType: ResponseType.arraybuffer,
    ///  onDownloadProgress: (total, current) {
    ///    final percentCompleted = (current / total * 100).round();
    ///    print('completed: $percentCompleted%');
    ///  },
    /// ).then((response) async {
    ///   await File('ada_lovelace.jpg').writeAsBytes(response.data);
    /// });
    /// ```
    DownloadCallback? onDownloadProgress,

    /// Using the validateStatus config option,
    /// you can define HTTP code(s) that should throw an error.
    /// ```dart
    /// axios.get('/user/12345', {
    ///   validateStatus: (status) {
    ///     return status < 500; // Resolve only if the status code is less than 500
    ///   }
    /// });
    /// ```
    ValidateCallback? validateStatus,
  });

  /// Aliase to `GET` method.
  Future<Response> post(
    String url, {
    /// Time that the server will wait for the response to the request.
    /// The connection will be interrupted if you hear timeout.
    Duration? timeout,

    /// Adds query params.
    /// Must be a plain object or a URLSearchParams object.;
    /// exe:
    ///```dart
    /// uno.get('/users',params: {
    ///   'id': '1',
    /// });
    /// ```
    /// This generate ['/users?id=1'];
    Map<String, String> params = const {},

    /// Headers of request.
    Map<String, String> headers = const {},

    /// Represents the [Response] data type.
    /// Could use:
    /// ```dart
    /// ResponseType.json //default
    /// ResponseType.plain
    /// ResponseType.arraybuffer
    /// ResponseType.stream
    /// ```
    ResponseType responseType = ResponseType.json,

    /// Callback from API to client about request`s upload.
    /// ```dart
    ///  uno(
    ///  method: 'get',
    ///  url: 'http://bit.ly/2mTM3nY',
    ///  // you can use plain, json(default), arraybuffer and stream;
    ///  responseType: ResponseType.arraybuffer,
    ///  onDownloadProgress: (total, current) {
    ///    final percentCompleted = (current / total * 100).round();
    ///    print('completed: $percentCompleted%');
    ///  },
    /// ).then((response) async {
    ///   await File('ada_lovelace.jpg').writeAsBytes(response.data);
    /// });
    /// ```
    DownloadCallback? onDownloadProgress,

    /// Using the validateStatus config option,
    /// you can define HTTP code(s) that should throw an error.
    /// ```dart
    /// axios.get('/user/12345', {
    ///   validateStatus: (status) {
    ///     return status < 500; // Resolve only if the status code is less than 500
    ///   }
    /// });
    /// ```
    ValidateCallback? validateStatus,

    /// `data` is the data to be sent as the request body
    /// Only applicable for request methods 'PUT', 'POST', 'DELETE , and 'PATCH'
    /// - String, Map(json) or FormData
    dynamic data,
  });

  /// Aliase to `GET` method.
  Future<Response> put(
    String url, {
    /// Time that the server will wait for the response to the request.
    /// The connection will be interrupted if you hear timeout.
    Duration? timeout,

    /// Adds query params.
    /// Must be a plain object or a URLSearchParams object.;
    /// exe:
    ///```dart
    /// uno.get('/users',params: {
    ///   'id': '1',
    /// });
    /// ```
    /// This generate ['/users?id=1'];
    Map<String, String> params = const {},

    /// Headers of request.
    Map<String, String> headers = const {},

    /// Represents the [Response] data type.
    /// Could use:
    /// ```dart
    /// ResponseType.json //default
    /// ResponseType.plain
    /// ResponseType.arraybuffer
    /// ResponseType.stream
    /// ```
    ResponseType responseType = ResponseType.json,

    /// Callback from API to client about request`s upload.
    /// ```dart
    ///  uno(
    ///  method: 'get',
    ///  url: 'http://bit.ly/2mTM3nY',
    ///  // you can use plain, json(default), arraybuffer and stream;
    ///  responseType: ResponseType.arraybuffer,
    ///  onDownloadProgress: (total, current) {
    ///    final percentCompleted = (current / total * 100).round();
    ///    print('completed: $percentCompleted%');
    ///  },
    /// ).then((response) async {
    ///   await File('ada_lovelace.jpg').writeAsBytes(response.data);
    /// });
    /// ```
    DownloadCallback? onDownloadProgress,

    /// Using the validateStatus config option,
    /// you can define HTTP code(s) that should throw an error.
    /// ```dart
    /// axios.get('/user/12345', {
    ///   validateStatus: (status) {
    ///     return status < 500; // Resolve only if the status code is less than 500
    ///   }
    /// });
    /// ```
    ValidateCallback? validateStatus,

    /// `data` is the data to be sent as the request body
    /// Only applicable for request methods 'PUT', 'POST', 'DELETE , and 'PATCH'
    /// - String, Map(json) or FormData
    dynamic data,
  });

  /// Aliase to `GET` method.
  Future<Response> delete(
    String url, {
    /// Time that the server will wait for the response to the request.
    /// The connection will be interrupted if you hear timeout.
    Duration? timeout,

    /// Adds query params.
    /// Must be a plain object or a URLSearchParams object.;
    /// exe:
    ///```dart
    /// uno.get('/users',params: {
    ///   'id': '1',
    /// });
    /// ```
    /// This generate ['/users?id=1'];
    Map<String, String> params = const {},

    /// Headers of request.
    Map<String, String> headers = const {},

    /// Represents the [Response] data type.
    /// Could use:
    /// ```dart
    /// ResponseType.json //default
    /// ResponseType.plain
    /// ResponseType.arraybuffer
    /// ResponseType.stream
    /// ```
    ResponseType responseType = ResponseType.json,

    /// Callback from API to client about request`s upload.
    /// ```dart
    ///  uno(
    ///  method: 'get',
    ///  url: 'http://bit.ly/2mTM3nY',
    ///  // you can use plain, json(default), arraybuffer and stream;
    ///  responseType: ResponseType.arraybuffer,
    ///  onDownloadProgress: (total, current) {
    ///    final percentCompleted = (current / total * 100).round();
    ///    print('completed: $percentCompleted%');
    ///  },
    /// ).then((response) async {
    ///   await File('ada_lovelace.jpg').writeAsBytes(response.data);
    /// });
    /// ```
    DownloadCallback? onDownloadProgress,

    /// Using the validateStatus config option,
    /// you can define HTTP code(s) that should throw an error.
    /// ```dart
    /// axios.get('/user/12345', {
    ///   validateStatus: (status) {
    ///     return status < 500; // Resolve only if the status code is less than 500
    ///   }
    /// });
    /// ```
    ValidateCallback? validateStatus,

    /// `data` is the data to be sent as the request body
    /// Only applicable for request methods 'PUT', 'POST', 'DELETE , and 'PATCH'
    /// - String, Map(json) or FormData
    dynamic data,
  });

  /// Aliase to `GET` method.
  Future<Response> patch(
    String url, {
    /// Time that the server will wait for the response to the request.
    /// The connection will be interrupted if you hear timeout.
    Duration? timeout,

    /// Adds query params.
    /// Must be a plain object or a URLSearchParams object.;
    /// exe:
    ///```dart
    /// uno.get('/users',params: {
    ///   'id': '1',
    /// });
    /// ```
    /// This generate ['/users?id=1'];
    Map<String, String> params = const {},

    /// Headers of request.
    Map<String, String> headers = const {},

    /// Represents the [Response] data type.
    /// Could use:
    /// ```dart
    /// ResponseType.json //default
    /// ResponseType.plain
    /// ResponseType.arraybuffer
    /// ResponseType.stream
    /// ```
    ResponseType responseType = ResponseType.json,

    /// Callback from API to client about request`s upload.
    /// ```dart
    ///  uno(
    ///  method: 'get',
    ///  url: 'http://bit.ly/2mTM3nY',
    ///  // you can use plain, json(default), arraybuffer and stream;
    ///  responseType: ResponseType.arraybuffer,
    ///  onDownloadProgress: (total, current) {
    ///    final percentCompleted = (current / total * 100).round();
    ///    print('completed: $percentCompleted%');
    ///  },
    /// ).then((response) async {
    ///   await File('ada_lovelace.jpg').writeAsBytes(response.data);
    /// });
    /// ```
    DownloadCallback? onDownloadProgress,

    /// Using the validateStatus config option,
    /// you can define HTTP code(s) that should throw an error.
    /// ```dart
    /// axios.get('/user/12345', {
    ///   validateStatus: (status) {
    ///     return status < 500; // Resolve only if the status code is less than 500
    ///   }
    /// });
    /// ```
    ValidateCallback? validateStatus,

    /// `data` is the data to be sent as the request body
    /// Only applicable for request methods 'PUT', 'POST', 'DELETE , and 'PATCH'
    /// - String, Map(json) or FormData
    dynamic data,
  });

  /// Aliase to `GET` method.
  Future<Response> head(
    String url, {
    /// Time that the server will wait for the response to the request.
    /// The connection will be interrupted if you hear timeout.
    Duration? timeout,

    /// Adds query params.
    /// Must be a plain object or a URLSearchParams object.;
    /// exe:
    ///```dart
    /// uno.get('/users',params: {
    ///   'id': '1',
    /// });
    /// ```
    /// This generate ['/users?id=1'];
    Map<String, String> params = const {},

    /// Headers of request.
    Map<String, String> headers = const {},

    /// Represents the [Response] data type.
    /// Could use:
    /// ```dart
    /// ResponseType.json //default
    /// ResponseType.plain
    /// ResponseType.arraybuffer
    /// ResponseType.stream
    /// ```
    ResponseType responseType = ResponseType.json,

    /// Callback from API to client about request`s upload.
    /// ```dart
    ///  uno(
    ///  method: 'get',
    ///  url: 'http://bit.ly/2mTM3nY',
    ///  // you can use plain, json(default), arraybuffer and stream;
    ///  responseType: ResponseType.arraybuffer,
    ///  onDownloadProgress: (total, current) {
    ///    final percentCompleted = (current / total * 100).round();
    ///    print('completed: $percentCompleted%');
    ///  },
    /// ).then((response) async {
    ///   await File('ada_lovelace.jpg').writeAsBytes(response.data);
    /// });
    /// ```
    DownloadCallback? onDownloadProgress,

    /// Using the validateStatus config option,
    /// you can define HTTP code(s) that should throw an error.
    /// ```dart
    /// axios.get('/user/12345', {
    ///   validateStatus: (status) {
    ///     return status < 500; // Resolve only if the status code is less than 500
    ///   }
    /// });
    /// ```
    ValidateCallback? validateStatus,
  });

  /// Send a complete Request object.
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
    Duration? timeout,
    Map<String, String> params = const {},
    Map<String, String> headers = const {},
    ResponseType responseType = ResponseType.json,
    ValidateCallback? validateStatus,
    DownloadCallback? onDownloadProgress,
  }) {
    return call(
      url: url,
      params: params,
      headers: headers,
      responseType: responseType,
      validateStatus: validateStatus,
      timeout: timeout,
      onDownloadProgress: onDownloadProgress,
    );
  }

  @override
  Future<Response> delete(
    String url, {
    Duration? timeout,
    Map<String, String> params = const {},
    Map<String, String> headers = const {},
    ResponseType responseType = ResponseType.json,
    ValidateCallback? validateStatus,
    DownloadCallback? onDownloadProgress,
    dynamic data,
  }) {
    return call(
      url: url,
      method: 'delete',
      params: params,
      headers: headers,
      responseType: responseType,
      onDownloadProgress: onDownloadProgress,
      validateStatus: validateStatus,
      timeout: timeout,
      data: data,
    );
  }

  @override
  Future<Response> head(
    String url, {
    Duration? timeout,
    Map<String, String> params = const {},
    Map<String, String> headers = const {},
    ResponseType responseType = ResponseType.json,
    ValidateCallback? validateStatus,
    DownloadCallback? onDownloadProgress,
  }) {
    return call(
      url: url,
      method: 'head',
      params: params,
      headers: headers,
      timeout: timeout,
      responseType: responseType,
      validateStatus: validateStatus,
      onDownloadProgress: onDownloadProgress,
    );
  }

  @override
  Future<Response> patch(
    String url, {
    Duration? timeout,
    Map<String, String> params = const {},
    Map<String, String> headers = const {},
    ResponseType responseType = ResponseType.json,
    DownloadCallback? onDownloadProgress,
    ValidateCallback? validateStatus,
    dynamic data,
  }) {
    return call(
      url: url,
      method: 'patch',
      params: params,
      headers: headers,
      data: data,
      timeout: timeout,
      responseType: responseType,
      validateStatus: validateStatus,
      onDownloadProgress: onDownloadProgress,
    );
  }

  @override
  Future<Response> post(
    String url, {
    Duration? timeout,
    Map<String, String> params = const {},
    Map<String, String> headers = const {},
    ResponseType responseType = ResponseType.json,
    DownloadCallback? onDownloadProgress,
    ValidateCallback? validateStatus,
    dynamic data,
  }) {
    return call(
      url: url,
      method: 'post',
      params: params,
      headers: headers,
      data: data,
      timeout: timeout,
      validateStatus: validateStatus,
      responseType: responseType,
      onDownloadProgress: onDownloadProgress,
    );
  }

  @override
  Future<Response> put(
    String url, {
    Duration? timeout,
    Map<String, String> params = const {},
    Map<String, String> headers = const {},
    ResponseType responseType = ResponseType.json,
    DownloadCallback? onDownloadProgress,
    ValidateCallback? validateStatus,
    dynamic data,
  }) {
    return call(
      url: url,
      method: 'put',
      params: params,
      headers: headers,
      data: data,
      timeout: timeout,
      responseType: responseType,
      validateStatus: validateStatus,
      onDownloadProgress: onDownloadProgress,
    );
  }

  @override
  Future<Response> call({
    required String url,
    String method = 'get',
    Duration? timeout,
    Map<String, String> params = const {},
    Map<String, String> headers = const {},
    ResponseType responseType = ResponseType.json,
    DownloadCallback? onDownloadProgress,
    ValidateCallback? validateStatus,
    dynamic data,
  }) async {
    url = '&$baseURL$url${_encodeParamsToQueries(params)}';

    final _headers = <String, String>{}
      ..addAll(this.headers)
      ..addAll(headers);

    final uri = Uri.parse(url);
    var myRequest = Request(
      timeout: timeout ?? this.timeout,
      uri: uri,
      headers: _headers,
      method: method,
      responseType: responseType,
      validateStatus: validateStatus,
      onDownloadProgress: onDownloadProgress,
    );

    if (data is FormData) {
      _headers.addAll(data.getHeaders());
      myRequest = myRequest.copyWith(bodyBytes: data.body, headers: _headers);
    }

    if (data is Map) {
      var value = '';
      if (headers.containsKey(HttpHeaders.contentTypeHeader)) {
        final contentType = headers[HttpHeaders.contentTypeHeader]!;
        if (contentType.contains('x-www-form-urlencoded')) {
          value = _encodeParamsToQueries(data.cast());
        }
      } else {
        value = jsonEncode(data);
      }

      final bytes = utf8.encode(value);
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
    final result = await fetch(request: request);

    return await result.fold((l) async {
      final resolved = await interceptors.response._resolveError(l);
      if (resolved is Response) {
        return resolved;
      }
      throw resolved;
    }, (r) async {
      return interceptors.response._resolve(r);
    });
  }

  String _encodeParamsToQueries(
    Map<String, String> params,
  ) {
    if (params.isEmpty) {
      return '';
    }
    final buffer = StringBuffer();
    for (final key in params.keys) {
      final value = params[key];
      final query = '$key=${Uri.encodeQueryComponent(value.toString())}&';
      buffer.write(query);
    }
    final encoded = buffer.toString();
    return (encoded.characters.toList()..removeLast()).join();
  }
}
