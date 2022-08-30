import 'package:mobx_triple/mobx_triple.dart';
import 'package:uno_example/features/get/domain/entities/request_entity.dart';

import '../domain/usecases/send_put_usecase.dart';


class SendPutStore extends MobXStore<Exception, RequestEntity> {
  final ISendPut usecase;
  SendPutStore(this.usecase) :  super(RequestEntity(body: '', title: ''));

  Future<void> sendPut() async {
  final entity = RequestEntity(title: 'teste', body: 'body', id: 1);
    setLoading(true);
    await Future.delayed(const Duration(seconds: 2));
    final result = await usecase.sendPut(entity);
    result.fold((l) {
      setError(l);
      setLoading(false);
    }, update,);
  }
}
