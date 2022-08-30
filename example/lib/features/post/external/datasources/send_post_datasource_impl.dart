import 'package:uno/uno.dart';
import 'package:uno_example/features/get/domain/entities/request_entity.dart';

import '../../infra/datasources/send_post_datasource.dart';

class SendPostDataSource implements ISendPostDataSource {
  late Uno uno;
  SendPostDataSource(this.uno);

  @override
  Future<RequestEntity> postTest(RequestEntity entity) async {
    try {
      final response = await uno.post(
        'https://jsonplaceholder.typicode.com/posts/?title=${entity.title}&body=${entity.body}',
      );
      if (response.status == 201) {
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
