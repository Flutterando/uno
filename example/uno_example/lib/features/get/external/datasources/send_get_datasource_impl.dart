import 'package:uno/uno.dart';

import '../../../post/infra/models/post_entity_dto.dart';
import '../../infra/datasources/send_get_datasource.dart';

class SendGetDataSource implements ISendGetDataSource {
  late Uno uno;

  SendGetDataSource(this.uno);

  @override
  Future<List<dynamic>> sendGet() async {
   
    try {
      final response = await uno.get('https://jsonplaceholder.typicode.com/posts');
      if (response.status == 200) {
        final list = ((response.data as List)
          .map((e) => RequestEntityDto.fromMap(e))
          .toList());
        return list;
      } else {
        throw Exception();
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
