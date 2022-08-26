import 'package:dartz/dartz.dart';
import 'package:uno_example/features/delete/domain/usecases/send_delete_usecase.dart';

import '../../../get/domain/entities/request_entity.dart';
import '../../domain/repositories/send_delete_repository.dart';

class SendDeleteUseCase implements ISendDelete {
  final ISendDeleteRepository _repository;

  SendDeleteUseCase(this._repository);

  @override
  Future<Either<Exception, RequestEntity>> sendDelete(RequestEntity entity) {
    var results = _repository.sendDelete(entity);
    return results;
  }
}
