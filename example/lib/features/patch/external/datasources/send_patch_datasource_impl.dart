import 'package:uno/uno.dart';

import '../../../get/domain/entities/request_entity.dart';
import '../../infra/datasources/send_patch_datasource.dart';

class SendPatchDataSource implements ISendPatchDataSource {
  late Uno uno;
  final entity = RequestEntity(body: 'Hello', title: 'patch test', id: 1);

  SendPatchDataSource(this.uno);

  @override
  Future<RequestEntity> sendPatch(RequestEntity entity) async {
    try {
      final response = await uno.patch('https://jsonplaceholder.typicode.com/posts/${entity.id}');
      if (response.status != 404) {
        return RequestEntity(
          title: 'title',
          body: 'body',
          status: response.status,
        );
      } else {
        throw Exception();
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
