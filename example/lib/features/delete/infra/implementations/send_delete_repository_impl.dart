import 'package:dartz/dartz.dart';

import '../../../get/domain/entities/request_entity.dart';
import '../../domain/repositories/send_delete_repository.dart';
import '../datasources/send_delete_datasource.dart';

class SendDeleteRepository implements ISendDeleteRepository {
  final ISendDeleteDataSource dataSource;

  SendDeleteRepository(this.dataSource);

  @override
  Future<Either<Exception, RequestEntity>> sendDelete(
      RequestEntity entity) async {
    try {
      final result = await dataSource.sendDelete(entity);

      return Right(result);
    } catch (e) {
      return Left(Exception());
    }
  }
}
