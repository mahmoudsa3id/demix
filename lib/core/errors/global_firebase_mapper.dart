import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'app_failure.dart';

class FirebaseFailureMapper {
  FirebaseFailureMapper._();

  static AppFailure map(Object error) {
    if (error is FirebaseAuthException) {
      return _mapAuth(error);
    }

    if (error is FirebaseException) {
      return _mapFirebase(error);
    }

    return AppFailure(
      kind: FailureKind.unknown,
      message: 'errors.unknown',
      cause: error,
    );
  }

  // ===========================================================================
  // Firebase Auth
  // ===========================================================================

  static AppFailure _mapAuth(FirebaseAuthException e) {
    switch (e.code) {
      // -----------------------------------------------------------------------
      // Validation
      // -----------------------------------------------------------------------

      case 'invalid-email':
        return AuthFailure(
          kind: FailureKind.validation,
          message: 'auth.invalidEmail',
          code: e.code,
          cause: e,
        );

      case 'weak-password':
        return AuthFailure(
          kind: FailureKind.validation,
          message: 'auth.weakPassword',
          code: e.code,
          cause: e,
        );

      case 'email-already-in-use':
        return AuthFailure(
          kind: FailureKind.validation,
          message: 'auth.emailAlreadyInUse',
          code: e.code,
          cause: e,
        );

      // -----------------------------------------------------------------------
      // Authentication
      // -----------------------------------------------------------------------

      case 'user-not-found':
        return AuthFailure(
          kind: FailureKind.notFound,
          message: 'auth.userNotFound',
          code: e.code,
          cause: e,
        );

      case 'wrong-password':
      case 'invalid-credential':
        return AuthFailure(
          kind: FailureKind.unauthenticated,
          message: 'auth.invalidCredentials',
          code: e.code,
          cause: e,
        );

      case 'user-disabled':
        return AuthFailure(
          kind: FailureKind.permissionDenied,
          message: 'auth.userDisabled',
          code: e.code,
          cause: e,
        );

      case 'requires-recent-login':
        return AuthFailure(
          kind: FailureKind.unauthenticated,
          message: 'auth.requiresRecentLogin',
          code: e.code,
          cause: e,
        );

      case 'user-token-expired':
      case 'id-token-expired':
        return AuthFailure(
          kind: FailureKind.unauthenticated,
          message: 'auth.sessionExpired',
          code: e.code,
          cause: e,
        );

      // -----------------------------------------------------------------------
      // Network
      // -----------------------------------------------------------------------

      case 'network-request-failed':
        return AuthFailure(
          kind: FailureKind.network,
          message: 'errors.network',
          code: e.code,
          cause: e,
        );

      // -----------------------------------------------------------------------
      // Rate Limit
      // -----------------------------------------------------------------------

      case 'too-many-requests':
        return AuthFailure(
          kind: FailureKind.rateLimited,
          message: 'errors.tooManyRequests',
          code: e.code,
          cause: e,
        );

      // -----------------------------------------------------------------------
      // Configuration
      // -----------------------------------------------------------------------

      case 'operation-not-allowed':
        return AuthFailure(
          kind: FailureKind.configuration,
          message: 'auth.operationNotAllowed',
          code: e.code,
          cause: e,
        );

      // -----------------------------------------------------------------------
      // OAuth
      // -----------------------------------------------------------------------

      case 'account-exists-with-different-credential':
        return AuthFailure(
          kind: FailureKind.validation,
          message: 'auth.accountExistsWithDifferentCredential',
          code: e.code,
          cause: e,
        );

      case 'credential-already-in-use':
        return AuthFailure(
          kind: FailureKind.validation,
          message: 'auth.credentialAlreadyInUse',
          code: e.code,
          cause: e,
        );

      case 'popup-closed-by-user':
      case 'cancelled-popup-request':
      case 'web-context-cancelled':
        return AuthFailure(
          kind: FailureKind.cancelled,
          message: 'errors.cancelled',
          code: e.code,
          cause: e,
        );

      case 'popup-blocked':
        return AuthFailure(
          kind: FailureKind.configuration,
          message: 'auth.popupBlocked',
          code: e.code,
          cause: e,
        );

      // -----------------------------------------------------------------------
      // Verification
      // -----------------------------------------------------------------------

      case 'invalid-verification-code':
        return AuthFailure(
          kind: FailureKind.validation,
          message: 'auth.invalidVerificationCode',
          code: e.code,
          cause: e,
        );

      case 'invalid-verification-id':
        return AuthFailure(
          kind: FailureKind.validation,
          message: 'auth.invalidVerificationId',
          code: e.code,
          cause: e,
        );

      // -----------------------------------------------------------------------
      // Unknown Auth Error
      // -----------------------------------------------------------------------

      default:
        return AuthFailure(
          kind: FailureKind.unknown,
          message: 'auth.authenticationFailed',
          code: e.code,
          cause: e,
        );
    }
  }

  // ===========================================================================
  // Firebase Core / Firestore / Storage / Functions
  // ===========================================================================

  static AppFailure _mapFirebase(FirebaseException e) {
    switch (e.code) {
      case 'permission-denied':
        return AppFailure(
          kind: FailureKind.permissionDenied,
          message: 'errors.permissionDenied',
          code: e.code,
          cause: e,
        );

      case 'unauthenticated':
        return AppFailure(
          kind: FailureKind.unauthenticated,
          message: 'errors.unauthenticated',
          code: e.code,
          cause: e,
        );

      case 'not-found':
        return AppFailure(
          kind: FailureKind.notFound,
          message: 'errors.notFound',
          code: e.code,
          cause: e,
        );

      case 'unavailable':
      case 'network-request-failed':
        return AppFailure(
          kind: FailureKind.network,
          message: 'errors.network',
          code: e.code,
          cause: e,
        );

      case 'deadline-exceeded':
        return AppFailure(
          kind: FailureKind.network,
          message: 'errors.timeout',
          code: e.code,
          cause: e,
        );

      case 'resource-exhausted':
        return AppFailure(
          kind: FailureKind.rateLimited,
          message: 'errors.resourceExhausted',
          code: e.code,
          cause: e,
        );

      case 'invalid-argument':
      case 'failed-precondition':
        return AppFailure(
          kind: FailureKind.validation,
          message: 'errors.invalidData',
          code: e.code,
          cause: e,
        );

      case 'already-exists':
        return AppFailure(
          kind: FailureKind.validation,
          message: 'errors.alreadyExists',
          code: e.code,
          cause: e,
        );

      case 'aborted':
      case 'internal':
      case 'data-loss':
        return AppFailure(
          kind: FailureKind.server,
          message: 'errors.server',
          code: e.code,
          cause: e,
        );

      default:
        return AppFailure(
          kind: FailureKind.unknown,
          message: 'errors.unknown',
          code: e.code,
          cause: e,
        );
    }
  }
}
