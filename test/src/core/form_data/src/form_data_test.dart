import 'package:test/test.dart';
import 'package:uno/uno.dart';

void main() {
  group('FormData encoder', () {
    test('works correctly with primitive data types', () async {
      final formData = FormData();

      // ignore: cascade_invocations
      formData
        ..boundary = '---123'
        ..add('name', 'Fisrtname McSurname')
        ..add('age', 10)
        ..add(
          'address',
          '''
some longer
        value with new lines and emojis 😃''',
        )
        ..addFile('image', 'mvvm.png');

      expect(formData.contentLength, equals(98262));
      expect(formData.getHeaders(), isA<Map>());
      expect(formData.body, isA<List<int>>());
    });
  });
}
