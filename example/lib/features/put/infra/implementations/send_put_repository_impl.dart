import 'package:dartz/dartz.dart';
import 'package:uno_example/features/get/domain/entities/request_entity.dart';

import '../../domain/repositories/send_put_repository.dart';
import '../datasources/send_put_datasource.dart';


class SendPutRepository implements ISendPutRepository {
 final ISendPutDataSource dataSource;

  SendPutRepository(this.dataSource);
  
  @override
  Future<Either<Exception, RequestEntity>> sendPut(RequestEntity entity)async  {
     try {
      final result = await dataSource.sendPut(entity);

      return Right(result);
    } catch (e) {
      return Left(Exception());
    }
  }
}
