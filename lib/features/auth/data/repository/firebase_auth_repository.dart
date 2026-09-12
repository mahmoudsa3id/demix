import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:demix/core/errors/global_firebase_mapper.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:demix/core/errors/app_failure.dart';

import 'package:demix/features/auth/data/data_source/firbase_auth_remote_source.dart';
import 'package:demix/features/auth/data/model/auth_model.dart';
import 'package:demix/features/auth/data/model/firebase_user_mapper.dart';

import 'package:demix/features/auth/domain/entities/auth_session.dart';
import 'package:demix/features/auth/domain/repository/auth_repository.dart';

class FirebaseAuthRepository implements AuthRepository {
  FirebaseAuthRepository({
    required this._authDataSource,
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseAuthDataSource _authDataSource;
  final FirebaseFirestore _firestore;

  // ===========================================================================
  // Auth State
  // ===========================================================================

  @override
  Stream<AuthSession?> get authStateChanges {
    return _authDataSource.authStateChanges.asyncMap((user) async {
      if (user == null) {
        return null;
      }

      try {
        final model = await _buildAuthModel(user);
        return model.toEntity();
      } catch (_) {
        return null;
      }
    });
  }

  // ===========================================================================
  // Email Login
  // ===========================================================================

  @override
  Future<Either<AppFailure, AuthSession>> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _authDataSource.signInWithEmail(
        email: email,
        password: password,
      );

      final user = credential.user;

      if (user == null) {
        return const Left(
          AuthFailure(
            kind: FailureKind.unknown,
            message: 'auth.authenticationFailed',
          ),
        );
      }

      final model = await _buildAuthModel(user);

      return Right(model.toEntity());
    } catch (e) {
      return Left(FirebaseFailureMapper.map(e));
    }
  }

  // ===========================================================================
  // Email Register
  // ===========================================================================

  @override
  Future<Either<AppFailure, AuthSession>> signUpWithEmail({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      final credential = await _authDataSource.signUpWithEmail(
        email: email,
        password: password,
      );

      final user = credential.user;

      if (user == null) {
        return const Left(
          AuthFailure(
            kind: FailureKind.unknown,
            message: 'auth.authenticationFailed',
          ),
        );
      }

      await _authDataSource.updateDisplayName(displayName: displayName);

      await _createUserProfile(user: user, displayName: displayName);

      await user.reload();

      final updatedUser = _authDataSource.currentUser;

      if (updatedUser == null) {
        return const Left(
          AuthFailure(
            kind: FailureKind.unknown,
            message: 'auth.authenticationFailed',
          ),
        );
      }

      final model = await _buildAuthModel(updatedUser);

      return Right(model.toEntity());
    } catch (e) {
      return Left(FirebaseFailureMapper.map(e));
    }
  }

  // ===========================================================================
  // Google
  // ===========================================================================

  @override
  Future<Either<AppFailure, AuthSession>> signInWithGoogle() async {
    try {
      final credential = await _authDataSource.signInWithGoogle();

      final user = credential.user;

      if (user == null) {
        return const Left(
          AuthFailure(
            kind: FailureKind.unknown,
            message: 'auth.authenticationFailed',
          ),
        );
      }

      await _createSocialUserProfile(user: user);

      final model = await _buildAuthModel(user);

      return Right(model.toEntity());
    } catch (e) {
      return Left(FirebaseFailureMapper.map(e));
    }
  }

  // ===========================================================================
  // Facebook
  // ===========================================================================

  @override
  Future<Either<AppFailure, AuthSession>> signInWithFacebook() async {
    try {
      final credential = await _authDataSource.signInWithFacebook();

      final user = credential.user;

      if (user == null) {
        return const Left(
          AuthFailure(
            kind: FailureKind.unknown,
            message: 'auth.authenticationFailed',
          ),
        );
      }

      await _createSocialUserProfile(user: user);

      final model = await _buildAuthModel(user);

      return Right(model.toEntity());
    } catch (e) {
      return Left(FirebaseFailureMapper.map(e));
    }
  }

  // ===========================================================================
  // Guest
  // ===========================================================================

  @override
  Future<Either<AppFailure, AuthSession>> signInAsGuest() async {
    try {
      final credential = await _authDataSource.signInAnonymously();

      final user = credential.user;

      if (user == null) {
        return const Left(
          AuthFailure(
            kind: FailureKind.unknown,
            message: 'auth.authenticationFailed',
          ),
        );
      }

      final model = await _buildAuthModel(user);

      return Right(model.toEntity());
    } catch (e) {
      return Left(FirebaseFailureMapper.map(e));
    }
  }

  // ===========================================================================
  // Password Reset
  // ===========================================================================

  @override
  Future<Either<AppFailure, Unit>> sendPasswordResetEmail({
    required String email,
  }) async {
    try {
      await _authDataSource.sendPasswordResetEmail(email: email);

      return const Right(unit);
    } catch (e) {
      return Left(FirebaseFailureMapper.map(e));
    }
  }

  // ===========================================================================
  // Sign Out
  // ===========================================================================

  @override
  Future<Either<AppFailure, Unit>> signOut() async {
    try {
      await _authDataSource.signOut();

      return const Right(unit);
    } catch (e) {
      return Left(FirebaseFailureMapper.map(e));
    }
  }

  // ===========================================================================
  // Build Auth Model
  // ===========================================================================

  Future<AuthModel> _buildAuthModel(User user) async {
    final roles = await _getUserRoles(user.uid, user: user);

    return FirebaseUserModelMapper.fromFirebaseUser(user, roles: roles);
  }

  // ===========================================================================
  // Firestore Roles
  // ===========================================================================

  Future<Set<UserRole>> _getUserRoles(String uid, {User? user}) async {
    final snapshot = await _firestore.collection('users').doc(uid).get();

    if (!snapshot.exists) {
      return {};
    }

    final data = snapshot.data();

    if (data == null) {
      return {};
    }

    final roles = data['roles'];

    if (roles is! List) {
      return {};
    }

    return roles
        .whereType<String>()
        .map(_mapRole)
        .whereType<UserRole>()
        .toSet();
  }

  // ===========================================================================
  // Create Email User
  // ===========================================================================

  Future<void> _createUserProfile({
    required User user,
    required String displayName,
  }) async {
    await _firestore.collection('users').doc(user.uid).set({
      'displayName': displayName,
      'email': user.email,
      'roles': ['customer'],
      'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  // ===========================================================================
  // Create Google / Facebook User
  // ===========================================================================

  Future<void> _createSocialUserProfile({required User user}) async {
    final reference = _firestore.collection('users').doc(user.uid);

    final snapshot = await reference.get();

    if (snapshot.exists) {
      return;
    }

    await reference.set({
      'displayName': user.displayName,
      'email': user.email,
      'phone': user.phoneNumber,
      'avatarUrl': user.photoURL,
      'roles': ['customer'],
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // ===========================================================================
  // Role Mapper
  // ===========================================================================

  UserRole? _mapRole(String role) {
    switch (role) {
      case 'customer':
        return UserRole.customer;

      case 'business':
        return UserRole.business;

      case 'driver':
        return UserRole.driver;

      case 'deliveryCompany':
        return UserRole.deliveryCompany;

      case 'admin':
        return UserRole.admin;

      default:
        return null;
    }
  }
}
