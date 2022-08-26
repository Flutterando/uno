import 'package:dartz/dartz.dart';


abstract class ISendGetUseCase{
  Future<Either<Exception, List<dynamic>>> sendGet();
}