import 'package:uno/src/domain/models/request.dart';

abstract class UnoError implements Exception {
  final String message;
  final dynamic data;
  final StackTrace? stackTrace;
  final Request? request;

  const UnoError(this.message, {this.data, this.stackTrace, this.request});
}
