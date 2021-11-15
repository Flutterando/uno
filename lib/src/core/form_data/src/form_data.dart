import 'dart:convert';

import 'package:mime_type/mime_type.dart';
import 'package:path/path.dart';

import 'entry.dart';
import 'result.dart';
import 'utils.dart';
import 'package:universal_io/io.dart' as io;

/// Used to generate form data.
class FormData {
  /// Encoding used in converting [String] to [List<int>]. Defaults to `utf8`.
  final Encoding encoding;

  /// Boundary used in the form data.
  String boundary = generateBoundary();

  final List<Entry> _entries = [];

  FormData({this.encoding = utf8});

  /// Add a field [name] to the form data.
  ///
  /// [value] will be converted to a string using [Object.toString] and encoded using [FormData.encoding].
  void add(String name, dynamic value) {
    _isDirty = true;
    _entries.add(
      Entry.value(encoding.encode(name), encoding.encode(value.toString())),
    );
  }

  /// Add a field [name] to the form data.
  ///
  /// [contents] will be added directly to the body, skipping encoding.
  void addBytes(String name, List<int> bytes,
      {String? contentType, String? filename}) {
    _isDirty = true;
    _entries.add(
      Entry.file(encoding.encode(name), bytes,
          contentType:
              contentType == null ? null : encoding.encode(contentType),
          filename: filename == null ? null : encoding.encode(filename)),
    );
  }

  /// Add a field [name] to the form data.
  ///
  /// [file] will be added directly to the body, skipping encoding.
  void addFile(String name, String filePath,
      {String? contentType, String? filename}) {
    filename ??= basename(filePath);
    contentType ??= mime(filename);
    addBytes(name, io.File(filePath).readAsBytesSync(),
        filename: filename, contentType: contentType);
  }

  bool _isDirty = true;
  FormDataResult? _lastResult;

  FormDataResult get _result {
    if (_isDirty || _lastResult == null) {
      _lastResult = _build();
    }

    return _lastResult!;
  }

  FormDataResult _build() => FormDataResult(List.from(_entries), boundary);

  /// Content-Type header value including the boundary.
  String get contentType => _result.contentType;

  /// Content-Length header value.
  int get contentLength => _result.contentLength;

  /// Actual body of the form-data.
  List<int> get body => _result.body;

  /// Gets custom headers for multpart form.
  Map<String, String> getHeaders() {
    return {
      'content-type': contentType,
      'content-length': '$contentLength',
    };
  }
}
