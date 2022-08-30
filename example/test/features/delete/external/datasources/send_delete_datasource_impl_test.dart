
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:uno/uno.dart';
import 'package:uno_example/features/delete/external/datasources/send_delete_datasource_impl.dart';
import 'package:uno_example/features/get/domain/entities/request_entity.dart';


class MockUno extends Mock implements Uno {}

void main() {
  final uno = MockUno();
  final dataSource = SendDeleteDataSource(uno);
   final entity = RequestEntity(body: 'Hello', title: 'post test', id: 1);

  group(SendDeleteDataSource, () {
    test('Should use a delete method', () async {
      final request = Request(
        headers: const {'test': 'test'},
        method: 'delete',
        timeout: const Duration(seconds: 30),
        uri: Uri.parse('https://jsonplaceholder.typicode.com/posts/${entity.id}'),
      );

      when(() => uno.delete(any())).thenAnswer(
        (_) async => Response(
          headers: const {'test': 'test'},
          request: request,
          status: 200,
          data: {},
        ),
      );

      final result = dataSource.sendDelete(entity);
      expect(result, completes);
    },);
  });
}
