import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:uno/uno.dart';
import 'package:uno_example/features/get/domain/entities/request_entity.dart';
import 'package:uno_example/features/post/external/datasources/send_post_datasource_impl.dart';

import '../../../../utils/api_response.dart';

class MockUno extends Mock implements Uno {}

void main() {
  final uno = MockUno();
  final dataSource = SendPostDataSource(uno);
  final entity = RequestEntity(body: 'Hello', title: 'post test');
  final request = Request(
    headers: const {'test': 'test'},
    method: 'post',
    timeout: const Duration(seconds: 30),
    uri: Uri.parse(
        'https://jsonplaceholder.typicode.com/posts/?title=${entity.title}&body=${entity.body}',),
  );

  group(SendPostDataSource, () {
    test('Should use a post method', () async {
      when(() => uno.post(any())).thenAnswer(
        (_) async =>Response(
          headers: const {'test': 'test'},
          request: request,
          status: 201,
          data: jsonDecode(postResponse),
        ),
      );
      final response = dataSource.postTest(entity);
      expect(response, completes);
    },);
  });
}
