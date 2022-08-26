import 'package:dartz/dartz.dart';

import '../../../get/domain/entities/request_entity.dart';
import '../../domain/repositories/send_patch_repository.dart';
import '../../domain/usecases/send_patch_usecase.dart';


class SendPatchUseCase implements ISendPatchUseCase{
   final ISendPatchRepository _repository;

  SendPatchUseCase(this._repository);

  @override
  Future<Either<Exception, RequestEntity>> sendPatch(entity) async {
    var results = _repository.sendPatch(entity);
    return results;
  }
}