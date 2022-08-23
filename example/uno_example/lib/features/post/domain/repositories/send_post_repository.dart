import 'package:dartz/dartz.dart';
import 'package:uno_example/features/get/domain/entities/request_entity.dart';

abstract class ISendPostRepository{
  Future<Either<Exception, RequestEntity>> postTest(RequestEntity entity);
}