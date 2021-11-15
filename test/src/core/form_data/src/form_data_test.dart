import 'dart:io';

import 'package:test/test.dart';
import 'package:uno/uno.dart';

void main() {
  group('FormData encoder', () {
    test('works correctly with primitive data types', () async {
      var formData = FormData();

      formData.boundary = '---123';

      formData.add('name', 'Fisrtname McSurname');
      formData.add('age', 10);
      formData.add('address', '''some longer
        value with new lines and emojis 😃''');

      formData.addFile('image', 'mvvm.png');

      expect(formData.contentLength, equals(98262));
      expect(formData.getHeaders(), isA<Map>());
      expect(formData.body, isA<List<int>>());
    });
  });
}
