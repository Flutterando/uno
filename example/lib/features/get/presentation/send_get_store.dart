import 'package:mobx_triple/mobx_triple.dart';

import '../domain/usecases/send_get_usecase.dart';

class GetFactStore extends MobXStore<Exception, List<dynamic>> {
  final ISendGetUseCase usecase;

  GetFactStore(this.usecase) : super(<dynamic>[]);

  Future<void> getFacts() async {
    setLoading(true);
    await Future.delayed(const Duration(seconds: 2));
    final result = await usecase.sendGet();
    result.fold((l) {
      setError(l);
      setLoading(false);
    }, (r) {
      update(r);
    });
  }
}
