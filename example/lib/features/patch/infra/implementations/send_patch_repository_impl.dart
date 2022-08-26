import 'package:dartz/dartz.dart';
import 'package:uno_example/features/get/domain/entities/request_entity.dart';

import '../../domain/repositories/send_patch_repository.dart';
import '../datasources/send_patch_datasource.dart';


class SendPatchRepository implements ISendPatchRepository {
  final ISendPatchDataSource dataSource;

  SendPatchRepository(this.dataSource);

  @override
  Future<Either<Exception, RequestEntity>> sendPatch(RequestEntity entity) async {
    try {
      final result = await dataSource.sendPatch(entity);

      return Right(result);
    } catch (e) {
      return Left(Exception());
    }
  }

}
