import 'dart:async';

import 'package:uno/src/core/types/either.dart';

import 'entities/response.dart';
import 'errors/errors.dart';

export 'dart:async';

export 'package:uno/src/core/form_data/form_data.dart';
export 'package:uno/src/core/types/either.dart';

export 'dto/request.dart';
export 'entities/response.dart';
export 'errors/errors.dart';
export 'repositories/http_repository.dart';
export 'usecases/fetch.dart';

///[FetchCallback] it's a typedef of FutureOr<Either<UnoError, Response>>
typedef FetchCallback = FutureOr<Either<UnoError, Response>>;
