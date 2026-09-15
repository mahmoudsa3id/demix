import 'package:dartz/dartz.dart';
import 'package:demix/core/errors/app_failure.dart';

import '../entities/account_user.dart';
import '../repositories/account_repository.dart';

class GetAccountUserUseCase {
  const GetAccountUserUseCase(this._repository);

  final AccountRepository _repository;

  Future<Either<AppFailure, AccountUser>> call() {
    return _repository.getCurrentUser();
  }
}
