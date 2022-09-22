import 'dart:convert';

import 'entry.dart';

///[FormDataResult] class
class FormDataResult {
  final List<Entry> _entries;

  /// Boundary of the form-data.
  final String boundary;

  /// Content type header including the boundary.
  String get contentType => 'multipart/form-data; boundary=$boundary';

  /// Actual body of the form-data.
  late final List<int> body;

  /// Length of the content.
  late final int contentLength;

  final List<int> _midBoundary;
  final List<int> _endBoundary;

  static final List<int> _lineBreak = utf8.encode('\r\n');
  static final List<int> _contentDispositionPrefix =
      utf8.encode('Content-Disposition: form-data; name="');
  static final List<int> _contentDispositionPostfix = utf8.encode('"');
  static final List<int> _contentDispositionInfix = utf8.encode(
    '"; filename="',
  );
  static final List<int> _contentTypePrefix = utf8.encode('Content-Type: ');

  // ignore: public_member_api_docs
  FormDataResult(this._entries, this.boundary)
      : _midBoundary = utf8.encode('--$boundary\r\n'),
        _endBoundary = utf8.encode('--$boundary--\r\n') {
    final _body = <int>[];

    for (final entry in _entries) {
      _body
        ..addAll(_midBoundary)
        ..addAll(_contentDispositionPrefix)
        ..addAll(entry.name);

      final value = entry.value;
      if (value is File) {
        final filename = value.filename;

        if (filename != null) {
          _body
            ..addAll(_contentDispositionInfix)
            ..addAll(filename);
        }
      }

      _body
        ..addAll(_contentDispositionPostfix)
        ..addAll(_lineBreak);

      if (value is File) {
        final contentType = value.contentType;

        if (contentType != null) {
          _body
            ..addAll(_contentTypePrefix)
            ..addAll(contentType)
            ..addAll(_lineBreak);
        }
      }

      _body
        ..addAll(_lineBreak)
        ..addAll(entry.value.bytes)
        ..addAll(_lineBreak);
    }

    _body.addAll(_endBoundary);

    body = List.unmodifiable(_body);
    contentLength = body.length;
  }
}
