import 'package:flutter_triple/flutter_triple.dart';
import 'package:uno_example/features/get/domain/entities/request_entity.dart';

import '../domain/usecases/send_post_usecase.dart';

class SendPostStore extends StreamStore<Exception, RequestEntity> {
  final ISendPost usecase;
  SendPostStore(this.usecase) : super(RequestEntity(body: '', title: ''));

  Future<void> sendPost() async {
    setLoading(true);

    final entity = RequestEntity(title: 'teste', body: 'body');
    await Future.delayed(const Duration(seconds: 2));
    final result = await usecase.postTest(entity);
    result.fold(setError, update);
    setLoading(false);
  }
}
