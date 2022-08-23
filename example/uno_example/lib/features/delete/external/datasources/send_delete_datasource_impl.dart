import 'package:uno/uno.dart';

import '../../../get/domain/entities/request_entity.dart';
import '../../infra/datasources/send_delete_datasource.dart';

class SendDeleteDataSource implements ISendDeleteDataSource {
  late Uno uno;
  final entity = RequestEntity(body: 'Hello', title: 'post test', id: 1);

  SendDeleteDataSource(this.uno);

  @override
  Future<RequestEntity> sendDelete(entity) async {
    try {
      final response = await uno
          .delete('https://jsonplaceholder.typicode.com/posts/${entity.id}');
      if (response.status != 404) {
        return RequestEntity(
            title: 'title', body: 'body', status: response.status);
      } else {
        throw Exception();
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
