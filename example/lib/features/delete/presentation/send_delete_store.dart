import 'package:mobx_triple/mobx_triple.dart';
import 'package:uno_example/features/delete/domain/usecases/send_delete_usecase.dart';

import '../../get/domain/entities/request_entity.dart';


class SendDeleteStore extends MobXStore<Exception, RequestEntity> {
  final ISendDelete usecase;
  SendDeleteStore(this.usecase) :  super(RequestEntity(title: '', body:''));

  Future<void> sendDelete() async {
  final entity = RequestEntity(title: '', body: '', id: 1);
    setLoading(true);
    await Future.delayed(const Duration(seconds: 2));
    final result = await usecase.sendDelete(entity);
    result.fold((l) {
      setError(l);
      setLoading(false);
    }, update,);
  }
}
