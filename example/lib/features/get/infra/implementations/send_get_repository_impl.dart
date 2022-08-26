import 'package:dartz/dartz.dart';

import '../../domain/repositories/send_get_repository.dart';
import '../datasources/send_get_datasource.dart';

class SendGetRepository implements ISendGetRepository {
  final ISendGetDataSource dataSource;

  SendGetRepository(this.dataSource);

  @override
  Future<Either<Exception, List<dynamic>>> sendGet() async {
    try {
      final result = await dataSource.sendGet();

      return Right(result);
    } catch (e) {
      return Left(Exception());
    }
  }
}
