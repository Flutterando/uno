import '../../../get/domain/entities/request_entity.dart';

abstract class ISendPatchDataSource{
  Future<RequestEntity> sendPatch(RequestEntity entity);
}