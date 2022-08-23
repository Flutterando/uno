import 'package:dartz/dartz.dart';
import 'package:uno_example/features/get/domain/entities/request_entity.dart';

import '../../domain/repositories/send_put_repository.dart';
import '../../domain/usecases/send_put_usecase.dart';


class SendPutUseCase implements ISendPut{
    final ISendPutRepository _repository;

  SendPutUseCase(this._repository);

  @override
  Future<Either<Exception, RequestEntity>> sendPut(RequestEntity entity) {
    var results = _repository.sendPut(entity);
    return results;
  }
  
}