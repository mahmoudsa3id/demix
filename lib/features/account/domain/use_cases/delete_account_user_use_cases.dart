import 'package:dartz/dartz.dart';
import 'package:demix/core/errors/app_failure.dart';

import '../repositories/account_repository.dart';

class DeleteAccountUseCase {
  const DeleteAccountUseCase(this._repository);

  final AccountRepository _repository;

  Future<Either<AppFailure, Unit>> call() {
    return _repository.deleteAccount();
  }
}
