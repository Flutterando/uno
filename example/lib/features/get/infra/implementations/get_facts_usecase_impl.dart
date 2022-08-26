import 'package:dartz/dartz.dart';

import '../../domain/repositories/send_get_repository.dart';
import '../../domain/usecases/send_get_usecase.dart';

class GetFactsUseCase implements ISendGetUseCase{
   final ISendGetRepository _repository;

  GetFactsUseCase(this._repository);

  @override
  Future<Either<Exception, List<dynamic>>> sendGet() async {
    var results = _repository.sendGet();
    return results;
  }
}