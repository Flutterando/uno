import 'package:dartz/dartz.dart';
import 'package:uno_example/features/get/domain/entities/request_entity.dart';
import 'package:uno_example/features/post/domain/repositories/send_post_repository.dart';
import 'package:uno_example/features/post/infra/datasources/send_post_datasource.dart';

class SendPostRepository implements ISendPostRepository {
  final ISendPostDataSource dataSource;

  SendPostRepository(this.dataSource);
  @override
  Future<Either<Exception, RequestEntity>> postTest(
      RequestEntity entity) async {
    try {
      final result = await dataSource.postTest(entity);

      return Right(result);
    } catch (e) {
      return Left(Exception());
    }
  }
}
