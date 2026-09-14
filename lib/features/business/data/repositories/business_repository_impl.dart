import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/errors/app_failure.dart';
import '../../domain/entities/business.dart';
import '../../domain/repositories/business_repository.dart';
import '../datasources/business_remote_data_source.dart';

class BusinessRepositoryImpl
    implements BusinessRepository {
  const BusinessRepositoryImpl({
    required BusinessRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  final BusinessRemoteDataSource _remoteDataSource;

  @override
  Future<Either<AppFailure, List<Business>>>
      getBusinessesByType(String type) async {
    try {
      if (type.trim().isEmpty) {
        return const Left(
          AppFailure(
            kind: FailureKind.validation,
            message: 'Business type is required.',
          ),
        );
      }

      final businesses =
          await _remoteDataSource.getBusinessesByType(
        type,
      );

      return Right(businesses);
    } on FirebaseException catch (e) {
      return Left(_mapFirebaseException(e));
    } catch (e) {
      return Left(
        AppFailure(
          kind: FailureKind.unknown,
          message: 'Unable to load businesses.',
          cause: e,
        ),
      );
    }
  }

  AppFailure _mapFirebaseException(
    FirebaseException e,
  ) {
    switch (e.code) {
      case 'permission-denied':
        return AppFailure(
          kind: FailureKind.permissionDenied,
          message:
              'You do not have permission to view businesses.',
          code: e.code,
          cause: e,
        );

      case 'unavailable':
      case 'deadline-exceeded':
        return AppFailure(
          kind: FailureKind.network,
          message:
              'Please check your internet connection.',
          code: e.code,
          cause: e,
        );

      case 'not-found':
        return AppFailure(
          kind: FailureKind.notFound,
          message:
              'Businesses data was not found.',
          code: e.code,
          cause: e,
        );

      default:
        return AppFailure(
          kind: FailureKind.unknown,
          message:
              e.message ??
              'Unable to load businesses.',
          code: e.code,
          cause: e,
        );
    }
  }
}
