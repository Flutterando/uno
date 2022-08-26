import 'package:uno_example/features/get/domain/entities/request_entity.dart';

abstract class ISendPostDataSource{
  Future<RequestEntity> postTest(RequestEntity entity);
}