class Request {
  final Uri uri;
  final Duration timeout;
  final String method;
  final Map<String, String> headers;
  final List<int> bodyBytes;
  final ResponseType responseType;
  final void Function(int total, int current)? onDownloadProgress;

  const Request({
    required this.uri,
    required this.method,
    required this.headers,
    this.bodyBytes = const [],
    required this.timeout,
    this.responseType = ResponseType.json,
    this.onDownloadProgress,
  });

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
}

enum ResponseType { plain, json, arraybuffer, stream }
