import 'package:test/test.dart';
import 'package:uno/src/domain/domain.dart';
import 'package:uno/src/inject_context.dart';

void main() {
  test('inject context register', () async {
    final context = InjectContext();
    context.register(() => 'test');
    expect(context.get<String>(), 'test');
  });

  test('inject context unregister', () async {
    final context = InjectContext();
    context.register(() => 'test');
    expect(context.get<String>(), 'test');

    context.unregister<String>();
    expect(() => context.get<String>(), throwsException);
  });

  test('inject context default config', () async {
    final context = InjectContext.defaultConfig();
    expect(context.get<Fetch>(), isA<FetchImpl>());
    context.clear();
  });
}
