import 'package:uno/src/domain/models/request.dart';
import 'package:uno/uno.dart';

class UnoError<TData> implements Exception {
  final String message;
  final TData? data;
  final StackTrace? stackTrace;
  final Request? request;
  final Response? response;

  const UnoError(this.message, {this.data, this.stackTrace, this.request, this.response});

  @override
  String toString() {
    return 'UnoError: $message\n${request.toString()}${stackTrace != null ? '\n\n' + stackTrace.toString() : ''}';
  }
}
