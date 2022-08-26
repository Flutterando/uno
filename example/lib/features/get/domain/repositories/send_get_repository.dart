import 'package:dartz/dartz.dart';


abstract class ISendGetRepository {
  Future<Either<Exception, List<dynamic>>> sendGet();
}
