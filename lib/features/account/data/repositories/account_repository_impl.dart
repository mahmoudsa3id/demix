import 'package:dartz/dartz.dart';
import 'package:demix/core/errors/app_failure.dart';
import 'package:demix/core/errors/global_firebase_mapper.dart';
import 'package:demix/features/account/data/data_source/account_remote_data_source.dart';

import '../../domain/entities/account_user.dart';
import '../../domain/repositories/account_repository.dart';

class AccountRepositoryImpl implements AccountRepository {
  AccountRepositoryImpl({required this._remoteDataSource});

  final AccountRemoteDataSource _remoteDataSource;

  @override
  Future<Either<AppFailure, AccountUser>> getCurrentUser() async {
    try {
      final model = await _remoteDataSource.getCurrentUser();

      return Right(model);
    } catch (e) {
      return Left(FirebaseFailureMapper.map(e));
    }
  }

  @override
  Future<Either<AppFailure, AccountUser>> updateProfile({
    required String displayName,
    String? phone,
  }) async {
    try {
      final model = await _remoteDataSource.updateProfile(
        displayName: displayName,
        phone: phone,
      );

      return Right(model);
    } catch (e) {
      return Left(FirebaseFailureMapper.map(e));
    }
  }

  @override
  Future<Either<AppFailure, Unit>> deleteAccount() async {
    try {
      await _remoteDataSource.deleteAccount();

      return const Right(unit);
    } catch (e) {
      return Left(FirebaseFailureMapper.map(e));
    }
  }
}
