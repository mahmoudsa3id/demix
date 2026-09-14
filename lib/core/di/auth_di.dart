import 'package:demix/features/auth/data/data_source/firbase_auth_remote_source.dart';
import 'package:demix/features/auth/data/repository/firebase_auth_repository.dart';
import 'package:demix/features/auth/domain/repository/auth_repository.dart';
import 'package:demix/features/auth/domain/use_cases/observe_auth_state_use_case.dart';
import 'package:demix/features/auth/domain/use_cases/send_password_reset_use_case.dart';
import 'package:demix/features/auth/domain/use_cases/sign_in_as_guest_use_case.dart';
import 'package:demix/features/auth/domain/use_cases/sign_in_with_email_use_case.dart';
import 'package:demix/features/auth/domain/use_cases/sign_in_with_facebook_use_case.dart';
import 'package:demix/features/auth/domain/use_cases/sign_in_with_google_use_case.dart';
import 'package:demix/features/auth/domain/use_cases/sign_out_use_case.dart';
import 'package:demix/features/auth/domain/use_cases/sign_up_with_email_use_case.dart';
import 'package:get_it/get_it.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

import 'package:demix/features/auth/presentation/cubit/auth_cubit.dart';

void setupAuthDependencies(GetIt getIt) {
  // ---------------------------------------------------------------------------
  // Firebase
  // ---------------------------------------------------------------------------

  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);

  getIt.registerLazySingleton<FirebaseFirestore>(
    () => FirebaseFirestore.instance,
  );

  // ---------------------------------------------------------------------------
  // Social Auth
  // ---------------------------------------------------------------------------

  getIt.registerLazySingleton<GoogleSignIn>(() => GoogleSignIn.instance);

  getIt.registerLazySingleton<FacebookAuth>(() => FacebookAuth.instance);

  // ---------------------------------------------------------------------------
  // Data Source
  // ---------------------------------------------------------------------------

  getIt.registerLazySingleton<FirebaseAuthDataSource>(
    () => FirebaseAuthDataSource(
      firebaseAuth: getIt<FirebaseAuth>(),
      googleSignIn: getIt<GoogleSignIn>(),
      facebookAuth: getIt<FacebookAuth>(),
    ),
  );

  // ---------------------------------------------------------------------------
  // Repository
  // ---------------------------------------------------------------------------

  getIt.registerLazySingleton<AuthRepository>(
    () => FirebaseAuthRepository(
      authDataSource: getIt<FirebaseAuthDataSource>(),
      firestore: getIt<FirebaseFirestore>(),
    ),
  );

  // ---------------------------------------------------------------------------
  // Use Cases
  // ---------------------------------------------------------------------------

  getIt.registerLazySingleton<SignInWithEmailUseCase>(
    () => SignInWithEmailUseCase(getIt<AuthRepository>()),
  );

  getIt.registerLazySingleton<SignUpWithEmailUseCase>(
    () => SignUpWithEmailUseCase(getIt<AuthRepository>()),
  );

  getIt.registerLazySingleton<SignInWithGoogleUseCase>(
    () => SignInWithGoogleUseCase(getIt<AuthRepository>()),
  );

  getIt.registerLazySingleton<SignInWithFacebookUseCase>(
    () => SignInWithFacebookUseCase(getIt<AuthRepository>()),
  );

  getIt.registerLazySingleton<SignInAsGuestUseCase>(
    () => SignInAsGuestUseCase(getIt<AuthRepository>()),
  );

  getIt.registerLazySingleton<SendPasswordResetEmailUseCase>(
    () => SendPasswordResetEmailUseCase(getIt<AuthRepository>()),
  );

  getIt.registerLazySingleton<SignOutUseCase>(
    () => SignOutUseCase(getIt<AuthRepository>()),
  );

  getIt.registerLazySingleton<ObserveAuthStateUseCase>(
    () => ObserveAuthStateUseCase(getIt<AuthRepository>()),
  );

  // ---------------------------------------------------------------------------
  // Cubit
  // ---------------------------------------------------------------------------

  getIt.registerFactory<AuthCubit>(
    () => AuthCubit(
      signInWithEmail: getIt<SignInWithEmailUseCase>(),
      signUpWithEmail: getIt<SignUpWithEmailUseCase>(),
      signInWithGoogle: getIt<SignInWithGoogleUseCase>(),
      signInWithFacebook: getIt<SignInWithFacebookUseCase>(),
      signInAsGuest: getIt<SignInAsGuestUseCase>(),
      sendPasswordResetEmail: getIt<SendPasswordResetEmailUseCase>(),
      signOut: getIt<SignOutUseCase>(),
      observeAuthState: getIt<ObserveAuthStateUseCase>(),
    ),
  );
}
