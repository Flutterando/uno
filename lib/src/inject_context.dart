import 'package:universal_io/io.dart';

import 'external/universal_http_client.dart';
import 'infra/infra.dart';

class InjectContext {
  final Map<Type, dynamic> _injections = {};

  void register<T extends Object>(T Function() value) {
    _injections[_getType<T>()] = value;
  }

  T call<T extends Object>() => get<T>();
  T get<T extends Object>() {
    final type = _getType<T>();
    if (_injections.containsKey(type)) {
      return _injections[_getType<T>()]();
    }
    throw Exception('Injection not found: ($type)');
  }

  void unregister<T extends Object>() {
    _injections.remove(_getType<T>());
  }

  static InjectContext defaultConfig() {
    final context = InjectContext();
    context.register<HttpClient>(() => HttpClient());
    context.register<HttpDatasource>(() => UniversalHttpClient(context()));
    context.register<HttpRepository>(() => HttpRepositoryImpl(context()));
    context.register<Fetch>(() => FetchImpl(context()));
    return context;
  }

  void clear() => _injections.clear();

  Type _getType<T>() => T;
}
