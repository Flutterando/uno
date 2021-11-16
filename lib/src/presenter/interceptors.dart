part of 'uno_base.dart';

class Interceptors {
  final request = _InterceptorCallback<Request>();
  final response = _InterceptorCallback<Response>();
}

class _InterceptorCallback<T> {
  final interceptors = <_InterceptorResolver<T>>[];
  _InterceptorResolver<T> use(FutureOr<T> Function(T) resolve,
      {FutureOr<dynamic> Function(UnoError)? onError,
      bool Function(T)? runWhen}) {
    final interceptor = _InterceptorResolver<T>(resolve, onError, runWhen);
    interceptors.add(interceptor);
    return interceptor;
  }

  void eject(_InterceptorResolver<T> interceptor) =>
      interceptors.remove(interceptor);

  Future<T> _resolve(T data) async {
    for (var interceptor in interceptors) {
      if (interceptor._runWhen?.call(data) == false) {
        continue;
      }
      data = await interceptor._resolve(data);
    }
    return data;
  }

  @visibleForTesting
  Future<T> resolveTest(T data) => _resolve(data);

  @visibleForTesting
  Future<dynamic> resolveErrorTest(UnoError error) => _resolveError(error);

  Future<dynamic> _resolveError(UnoError error) async {
    for (var interceptor in interceptors) {
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

class _InterceptorResolver<T> {
  final FutureOr<T> Function(T) _resolve;
  final FutureOr<dynamic> Function(UnoError)? _errorResolve;
  final bool Function(T)? _runWhen;

  _InterceptorResolver(this._resolve, this._errorResolve, this._runWhen);
}
