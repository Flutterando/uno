import 'package:uno/uno.dart';

/// Represents error of uno
///
///implements an [Exception]
///Overrides the toString() method with the error received
///using it's [message], the [request] received and checks if
///the [stackTrace] is different from null, if it is, returns it as a string
///otherwise, returns an empty string
class UnoError<TData> implements Exception {
  final String message;
  final TData? data;
  final StackTrace? stackTrace;
  final Request? request;
  final Response? response;

  const UnoError(
    this.message, {
    this.data,
    this.stackTrace,
    this.request,
    this.response,
  });

  @override
  String toString() {
    return ''''UnoError: $message\n${request.toString()}${stackTrace != null ? '\n\n$stackTrace' : ''}''';
  }
}
