import 'package:uno/src/domain/domain.dart';
import 'package:uno/uno.dart';

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

  Future<T> resolve(T data) async {
    for (var interceptor in interceptors) {
      if (interceptor._runWhen?.call(data) == false) {
        continue;
      }
      data = await interceptor._resolve(data);
    }
    return data;
  }

  Future<dynamic> resolveError(UnoError error) async {
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
