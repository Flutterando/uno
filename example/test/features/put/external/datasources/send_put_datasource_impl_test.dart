import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:uno/uno.dart';
import 'package:uno_example/features/get/domain/entities/request_entity.dart';
import 'package:uno_example/features/put/external/datasources/send_put_datasource_impl.dart';

import '../../../../utils/api_response.dart';

class MockUno extends Mock implements Uno {}

void main() {
  final uno = MockUno();
  final dataSource = SendPutDataSource(uno);
  final entity = RequestEntity(body: 'Hello', title: 'post test', id: 1);

  group(SendPutDataSource, () {
    test(
      'Should use a put method',
      () async {
        final request = Request(
          headers: const {'test': 'test'},
          method: 'put',
          timeout: const Duration(seconds: 30),
          uri: Uri.parse(
            'https://jsonplaceholder.typicode.com/posts/${entity.id}',
          ),
        );

        when(() => uno.put(any())).thenAnswer(
          (_) async => Response(
            headers: const {'test': 'test'},
            request: request,
            status: 200,
            data: jsonDecode(putResponse),
          ),
        );

        final result = dataSource.sendPut(entity);
        expect(result, completes);
      },
    );
  });
}
