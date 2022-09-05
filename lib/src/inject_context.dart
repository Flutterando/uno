// ignore_for_file: prefer_constructors_over_static_methods

import 'package:universal_io/io.dart';

import 'external/universal_http_client.dart';
import 'infra/infra.dart';

///[InjectContext] class
class InjectContext {
  ///The variable [_injections] it's the type Map<Type, dynamic>
  final Map<Type, dynamic> _injections = {};

  ///The method [register] it's the type void
  ///recive for params the function [value] and recive
  ///_injections[_getType<T>()] = value
  void register<T extends Object>(T Function() value) {
    _injections[_getType<T>()] = value;
  }

  ///The method [call] it's the type generics [T]
  /// and return get<T>()
  T call<T extends Object>() => get<T>();

  ///The method [get] has a return of type generics [T]
  T get<T extends Object>() {
    /// The variable [type] recive _getType<T>()
    final type = _getType<T>();

    ///Verify if _injections.containsKey(type) and
    ///return _injections[_getType<T>()]()
    ///if it's Error, get throw Exception('Injection not found: ($type)')
    if (_injections.containsKey(type)) {
      return _injections[_getType<T>()]();
    }
    throw Exception('Injection not found: ($type)');
  }

  ///The method [unregister] it's the type void
  /// and recive _injections.remove(_getType<T>());
  void unregister<T extends Object>() {
    _injections.remove(_getType<T>());
  }

  ///static [defaultConfig] it's the type [InjectContext]
  static InjectContext defaultConfig() {
    final context = InjectContext();
    context
      ..register<HttpClient>(() => HttpClient())
      ..register<HttpDatasource>(() => UniversalHttpClient(context()))
      ..register<HttpRepository>(() => HttpRepositoryImpl(context()))
      ..register<Fetch>(() => FetchImpl(context()));
    return context;
  }

  ///The method [clear] it's the type void
  /// and recive _injections.clear();
  void clear() => _injections.clear();

  Type _getType<T>() => T;
}
