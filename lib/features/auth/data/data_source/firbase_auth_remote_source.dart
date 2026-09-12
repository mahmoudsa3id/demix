import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthDataSource {
  FirebaseAuthDataSource({
    FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
    FacebookAuth? facebookAuth,
  }) : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
       _googleSignIn = googleSignIn ?? GoogleSignIn.instance,
       _facebookAuth = facebookAuth ?? FacebookAuth.instance;

  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final FacebookAuth _facebookAuth;

  bool _googleInitialized = false;

  // ---------------------------------------------------------------------------
  // Firebase
  // ---------------------------------------------------------------------------

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  User? get currentUser => _firebaseAuth.currentUser;

  // ---------------------------------------------------------------------------
  // Email / Password
  // ---------------------------------------------------------------------------

  Future<UserCredential> signInWithEmail({
    required String email,
    required String password,
  }) {
    return _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> signUpWithEmail({
    required String email,
    required String password,
  }) {
    return _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> updateDisplayName({required String displayName}) async {
    await _firebaseAuth.currentUser?.updateDisplayName(displayName);

    await _firebaseAuth.currentUser?.reload();
  }

  Future<void> sendPasswordResetEmail({required String email}) {
    return _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  // ---------------------------------------------------------------------------
  // Guest
  // ---------------------------------------------------------------------------

  Future<UserCredential> signInAnonymously() {
    return _firebaseAuth.signInAnonymously();
  }

  // ---------------------------------------------------------------------------
  // Google
  // ---------------------------------------------------------------------------

  Future<UserCredential> signInWithGoogle() async {
    await _initializeGoogle();

    final googleUser = await _googleSignIn.authenticate();

    final googleAuthentication = googleUser.authentication;

    final idToken = googleAuthentication.idToken;

    if (idToken == null) {
      throw FirebaseAuthException(
        code: 'google-missing-id-token',
        message: 'Google ID token is missing.',
      );
    }

    final credential = GoogleAuthProvider.credential(idToken: idToken);

    return _firebaseAuth.signInWithCredential(credential);
  }

  Future<void> signOutGoogle() async {
    if (!_googleInitialized) {
      return;
    }

    await _googleSignIn.signOut();
  }

  Future<void> _initializeGoogle() async {
    if (_googleInitialized) {
      return;
    }

    await _googleSignIn.initialize();

    _googleInitialized = true;
  }

  // ---------------------------------------------------------------------------
  // Facebook
  // ---------------------------------------------------------------------------

  // ---------------------------------------------------------------------------
  // Facebook
  // ---------------------------------------------------------------------------
  Future<UserCredential> signInWithFacebook() async {
    try {
      print('🟦 FACEBOOK LOGIN: START');

      final result = await _facebookAuth.login(
        permissions: const ['email', 'public_profile'],
      );

      print('🟦 FACEBOOK STATUS: ${result.status}');
      print('🟦 FACEBOOK MESSAGE: ${result.message}');
      print('🟦 FACEBOOK ACCESS TOKEN: ${result.accessToken}');

      if (result.status == LoginStatus.cancelled) {
        print('🟡 FACEBOOK LOGIN CANCELLED');

        throw FirebaseAuthException(code: 'cancelled', message: result.message);
      }

      if (result.status != LoginStatus.success) {
        print('🔴 FACEBOOK LOGIN FAILED');
        print('🔴 STATUS: ${result.status}');
        print('🔴 MESSAGE: ${result.message}');

        throw FirebaseAuthException(
          code: 'authentication-failed',
          message: result.message,
        );
      }

      final accessToken = result.accessToken;

      if (accessToken == null) {
        print('🔴 FACEBOOK ACCESS TOKEN IS NULL');

        throw FirebaseAuthException(
          code: 'invalid-credential',
          message: 'Facebook access token is missing.',
        );
      }

      print('🟢 FACEBOOK ACCESS TOKEN RECEIVED');
      print('🟢 TOKEN TYPE: ${accessToken.type}');
      print('🟢 TOKEN STRING: ${accessToken.tokenString}');

      final credential = FacebookAuthProvider.credential(
        accessToken.tokenString,
      );

      print('🟦 FACEBOOK FIREBASE CREDENTIAL CREATED');

      final userCredential = await _firebaseAuth.signInWithCredential(
        credential,
      );

      print('🟢 FIREBASE FACEBOOK LOGIN SUCCESS');
      print('🟢 USER UID: ${userCredential.user?.uid}');
      print('🟢 USER EMAIL: ${userCredential.user?.email}');
      print('🟢 USER NAME: ${userCredential.user?.displayName}');

      return userCredential;
    } catch (e, stackTrace) {
      print('════════════════════════════════════════');
      print('🔴 FACEBOOK LOGIN EXCEPTION');
      print('🔴 ERROR TYPE: ${e.runtimeType}');
      print('🔴 ERROR: $e');

      if (e is FirebaseAuthException) {
        print('🔴 FIREBASE CODE: ${e.code}');
        print('🔴 FIREBASE MESSAGE: ${e.message}');
        print('🔴 FIREBASE PLUGIN: ${e.plugin}');
      }

      print('🔴 STACK TRACE:');
      print(stackTrace);
      print('════════════════════════════════════════');

      rethrow;
    }
  }

  Future<void> signOutFacebook() async {
    await _facebookAuth.logOut();
  }
  // ---------------------------------------------------------------------------
  // Firebase Credential
  // ---------------------------------------------------------------------------

  Future<UserCredential> signInWithCredential(AuthCredential credential) {
    return _firebaseAuth.signInWithCredential(credential);
  }

  // ---------------------------------------------------------------------------
  // Sign out
  // ---------------------------------------------------------------------------

  Future<void> signOut() async {
    await _firebaseAuth.signOut();

    await Future.wait([_safeGoogleSignOut(), _safeFacebookSignOut()]);
  }

  Future<void> _safeGoogleSignOut() async {
    try {
      await signOutGoogle();
    } catch (_) {}
  }

  Future<void> _safeFacebookSignOut() async {
    try {
      await signOutFacebook();
    } catch (_) {}
  }
}
