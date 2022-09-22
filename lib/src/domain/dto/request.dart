///[ValidateCallback] it's a typedef of bool Function(int status)
typedef ValidateCallback = bool Function(int status);

/// Represents the request that will be sent to the http server.
class Request {
  /// A parsed URI, such as a URL.
  final Uri uri;

  /// Time that the server will wait for the response to the request.
  /// The connection will be interrupted if you hear timeout.
  final Duration timeout;

  /// Represents the request method. ex: [GET, POST, PUT, DELETE, PATCH, HEAD].
  ///
  /// Post Example:
  /// ```dart
  ///  Future<RequestEntity> postTest(entity) async {
  ///  try {
  ///    final response = await uno.post('https://jsonplaceholder.typicode.com/posts/?title=${entity.title}&body=${entity.body}');
  ///    if (response.status == 201) {
  ///
  ///      return RequestEntity(title: 'title', body: 'body',
  /// status: response.status);
  ///    } else {
  ///      throw Exception();
  ///    }
  ///  } catch (e) {
  ///    throw Exception(e);
  ///  }
  /// }
  /// ```
  final String method;

  /// Headers of request.
  final Map<String, String> headers;

  /// Buffer of data that will be sent to the server.
  final List<int> bodyBytes;

  /// Represents the Response data type.
  /// Could use:
  /// ```dart
  /// ResponseType.json //default
  /// ResponseType.plain
  /// ResponseType.arraybuffer
  /// ResponseType.stream
  /// ```
  final ResponseType responseType;

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
  final void Function(int total, int current)? onDownloadProgress;

  /// Using the validateStatus config option, you can define HTTP code(s) that
  /// should throw an error.
  /// ```dart
  /// axios.get('/user/12345', {
  ///   validateStatus: (status) {
  ///     return status < 500; // Resolve only if the status code is less than 500
  ///   }
  /// });
  /// ```
  late final ValidateCallback validateStatus;

  ///[Request] constructor class
  Request({
    required this.uri,
    required this.method,
    required this.headers,
    ValidateCallback? validateStatus,
    this.bodyBytes = const [],
    required this.timeout,
    this.responseType = ResponseType.json,
    this.onDownloadProgress,
  }) {
    this.validateStatus = validateStatus ??
        (
          status,
        ) =>
            status >= 200 && status < 300;
  }

  /// Create a new copy of request object.
  Request copyWith({
    Uri? uri,
    Duration? timeout,
    String? method,
    Map<String, String>? headers,
    List<int>? bodyBytes,
    ResponseType? responseType,
    ValidateCallback? validateStatus,
    void Function(int total, int current)? onDownloadProgress,
  }) {
    return Request(
      uri: uri ?? this.uri,
      validateStatus: validateStatus ?? this.validateStatus,
      timeout: timeout ?? this.timeout,
      method: method ?? this.method,
      headers: headers ?? this.headers,
      bodyBytes: bodyBytes ?? this.bodyBytes,
      responseType: responseType ?? this.responseType,
      onDownloadProgress: onDownloadProgress ?? this.onDownloadProgress,
    );
  }

  @override
  String toString() {
    return 'url: ${uri.toString()}, method: $method';
  }
}

/// Represents the Response data type.
/// Could use:
/// ```dart
/// ResponseType.json //default
/// ResponseType.plain
/// ResponseType.arraybuffer
/// ResponseType.stream
/// ```
enum ResponseType {
  /// Response.data will return [Map] object.
  json,

  /// Response.data will return a [String]
  plain,

  /// Response.data will return a [List<int>]
  arraybuffer,

  /// Response.data will return a [Stream]
  stream,
}
