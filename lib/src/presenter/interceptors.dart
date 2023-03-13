// ignore_for_file: parameter_assignments

part of 'uno_base.dart';

///[Interceptors] class
class Interceptors {
  /// Manage request interceptors.
  ///
  /// [use]: Create a new interceptor.
  ///
  /// [inject]: Remove interceptor.
  ///
  /// ```dart
  /// uno.interceptors.request.use((request) {
  ///   return request;
  /// }, onError: (error) {
  ///   return error;
  /// });
  /// ```
  final request = InterceptorCallback<Request>();

  /// Manage response interceptors.
  ///
  /// [use]: Create a new interceptor.
  ///
  /// [inject]: Remove interceptor.
  ///
  /// ```dart
  /// uno.interceptors.response.use((response) {
  ///   return response;
  /// }, onError: (error) {
  ///   return error;
  /// });
  /// ```
  final response = InterceptorCallback<Response>();
}

/// Organize interceptors
class InterceptorCallback<T> {
  final _interceptors = <InterceptorResolver<T>>[];

  /// Creates a new interceptor.
  /// [resolve]: Resolve request or response.
  /// [onError]: Resolve error.
  /// [runWhen]: Condition of run interceptor.
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
  InterceptorResolver<T> use(
    FutureOr<T> Function(T) resolve, {
    FutureOr<dynamic> Function(UnoError)? onError,
    bool Function(T)? runWhen,
  }) {
    final interceptor = InterceptorResolver<T>(resolve, onError, runWhen);
    _interceptors.add(interceptor);
    return interceptor;
  }

  /// Remove an interceptor.
  /// ```dart
  /// final myInterceptor = uno.interceptors.request.use((request) {/*...*/});
  /// uno.interceptors.request.eject(myInterceptor);
  /// ```
  void eject(InterceptorResolver<T> interceptor) => _interceptors.remove(
        interceptor,
      );

  Future<T> _resolve(T data) async {
    for (final interceptor in _interceptors) {
      if (interceptor._runWhen?.call(data) == false) {
        continue;
      }
      data = await interceptor._resolve(data);
    }
    return data;
  }

  /// only test
  @visibleForTesting
  Future<T> resolveTest(T data) => _resolve(data);

  /// only test
  @visibleForTesting
  Future<dynamic> resolveErrorTest(UnoError error) => _resolveError(error);

  Future<dynamic> _resolveError(UnoError error) async {
    for (final interceptor in _interceptors) {
      final data = await interceptor._errorResolve?.call(error);
      if (data is Response) {
        return data;
      } else if (data is UnoError) {
        error = data;
      }
    }
    return error;
  }
}

/// Resolver interceptors
class InterceptorResolver<T> {
  final FutureOr<T> Function(T) _resolve;
  final FutureOr<dynamic> Function(UnoError)? _errorResolve;
  final bool Function(T)? _runWhen;

  /// Resolver interceptors
  InterceptorResolver(this._resolve, this._errorResolve, this._runWhen);
}
