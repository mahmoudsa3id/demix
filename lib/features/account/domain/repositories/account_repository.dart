import 'package:dartz/dartz.dart';
import 'package:demix/core/errors/app_failure.dart';

import '../entities/account_user.dart';

abstract class AccountRepository {
  Future<Either<AppFailure, AccountUser>> getCurrentUser();

  Future<Either<AppFailure, AccountUser>> updateProfile({
    required String displayName,
    String? phone,
  });

  Future<Either<AppFailure, Unit>> deleteAccount();
}
