import 'package:dartz/dartz.dart';
import 'package:uno_example/features/get/domain/entities/request_entity.dart';

import '../../domain/repositories/send_post_repository.dart';
import '../../domain/usecases/send_post_usecase.dart';

class SendPostUseCase implements ISendPost{
    final ISendPostRepository _repository;

  SendPostUseCase(this._repository);

  @override
  Future<Either<Exception, RequestEntity>> postTest(RequestEntity entity) {
    var results = _repository.postTest(entity);
    return results;
  }
  
}