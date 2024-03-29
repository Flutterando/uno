import 'package:uno/uno.dart';

/// Represents error of uno
///
///implements an [Exception]
///Overrides the toString() method with the error received
///using it's [message], the [request] received and checks if
///the [stackTrace] is different from null, if it is, returns it as a string
///otherwise, returns an empty string
class UnoError<TData> implements Exception {
  ///The variable [message] it's the type String
  final String message;

  ///The variable [data] it's the type TData
  final TData? data;

  ///The variable [stackTrace] it's the type StackTrace
  final StackTrace? stackTrace;

  ///The variable [request] it's the type Request
  final Request? request;

  ///The variable [response] it's the type Response
  final Response? response;

  ///[UnoError] constructor class
  const UnoError(
    this.message, {
    this.data,
    this.stackTrace,
    this.request,
    this.response,
  });

  @override
  String toString() {
    return ''''UnoError: $message\n$request${stackTrace != null ? '\n\n$stackTrace' : ''}''';
  }
}
