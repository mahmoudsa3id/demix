import 'package:dartz/dartz.dart';
import 'package:demix/core/errors/app_failure.dart';

import '../entities/account_user.dart';
import '../repositories/account_repository.dart';

class UpdateAccountProfileUseCase {
  const UpdateAccountProfileUseCase(this._repository);

  final AccountRepository _repository;

  Future<Either<AppFailure, AccountUser>> call({
    required String displayName,
    String? phone,
  }) {
    return _repository.updateProfile(displayName: displayName, phone: phone);
  }
}
