import 'package:dartz/dartz.dart';

import '../../../get/domain/entities/request_entity.dart';


abstract class ISendPatchUseCase {
  Future<Either<Exception, RequestEntity>> sendPatch(RequestEntity entity);
}
