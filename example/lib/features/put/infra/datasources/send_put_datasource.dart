import 'package:uno_example/features/get/domain/entities/request_entity.dart';

abstract class ISendPutDataSource {
  Future<RequestEntity> sendPut(RequestEntity entity);
}
