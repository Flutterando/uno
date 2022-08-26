import 'package:dartz/dartz.dart';

import '../../../get/domain/entities/request_entity.dart';


abstract class ISendPut{
  Future<Either<Exception, RequestEntity>> sendPut(RequestEntity entity);
}