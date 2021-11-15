class Request {
  final Uri uri;
  final Duration timeout;
  final String method;
  final Map<String, String> headers;
  final List<int> bodyBytes;
  final ResponseType responseType;
  final void Function(int total, int current)? onDownloadProgress;
  late final bool Function(int status) validateStatus;

  Request({
    required this.uri,
    required this.method,
    required this.headers,
    bool Function(int status)? validateStatus,
    this.bodyBytes = const [],
    required this.timeout,
    this.responseType = ResponseType.json,
    this.onDownloadProgress,
  }) {
    this.validateStatus = validateStatus ?? (status) => status >= 200 && status < 300;
  }

  Request copyWith({
    Uri? uri,
    Duration? timeout,
    String? method,
    Map<String, String>? headers,
    List<int>? bodyBytes,
    ResponseType? responseType,
    void Function(int total, int current)? onDownloadProgress,
  }) {
    return Request(
      uri: uri ?? this.uri,
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

enum ResponseType { plain, json, arraybuffer, stream }
