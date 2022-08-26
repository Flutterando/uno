
import '../../../get/domain/entities/request_entity.dart';

abstract class ISendDeleteDataSource {
  Future<RequestEntity> sendDelete(RequestEntity entity);
}