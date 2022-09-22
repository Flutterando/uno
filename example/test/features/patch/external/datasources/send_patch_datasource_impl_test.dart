import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:uno/uno.dart';
import 'package:uno_example/features/get/domain/entities/request_entity.dart';
import 'package:uno_example/features/patch/external/datasources/send_patch_datasource_impl.dart';

import '../../../../utils/api_response.dart';

class MockUno extends Mock implements Uno {}

void main() {
  final uno = MockUno();
  final dataSource = SendPatchDataSource(uno);
  final entity = RequestEntity(body: 'Hello', title: 'post test', id: 1);

  group(SendPatchDataSource, () {
    test(
      'Should use a patch method',
      () async {
        final request = Request(
          headers: const {'test': 'test'},
          method: 'patch',
          timeout: const Duration(seconds: 30),
          uri: Uri.parse(
              'https://jsonplaceholder.typicode.com/posts/${entity.id}'),
        );

        when(() => uno.patch(any())).thenAnswer(
          (_) async => Response(
            headers: const {'test': 'test'},
            request: request,
            status: 200,
            data: jsonDecode(api),
          ),
        );

        final result = dataSource.sendPatch(entity);
        expect(result, completes);
      },
    );
  });
}
