// ignore_for_file: unnecessary_lambdas

import 'package:uno/uno.dart';

import '../../../post/infra/models/post_entity_dto.dart';
import '../../infra/datasources/send_get_datasource.dart';

class SendGetDataSource implements ISendGetDataSource {
  late Uno uno;

  SendGetDataSource(this.uno);

  @override
  Future<List<dynamic>> sendGet() async {
    try {
      final response =
          await uno.get('https://jsonplaceholder.typicode.com/posts');
      if (response.status == 200) {
        // ignore: unnecessary_parenthesis
        final list = ((response.data as List)
            .map(
              (
                e,
              ) =>
                  RequestEntityDto.fromMap(e),
            )
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
