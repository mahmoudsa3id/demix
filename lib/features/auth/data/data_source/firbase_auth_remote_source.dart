import 'package:demix/core/errors/app_failure.dart';
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

  Future<UserCredential> signInWithFacebook() async {
    final result = await _facebookAuth.login();

    if (result.status == LoginStatus.cancelled) {
      throw const AuthFailure(
        kind: FailureKind.cancelled,
        message: 'Facebook login was cancelled.',
        code: 'facebook-login-cancelled',
      );
    }

    if (result.status != LoginStatus.success) {
      throw AuthFailure(
        message: result.message ?? 'Facebook login failed.',
        code: 'facebook-login-failed',
      );
    }

    final accessToken = result.accessToken;

    if (accessToken == null) {
      throw const AuthFailure(
        message: 'Facebook access token is missing.',
        code: 'facebook-missing-access-token',
      );
    }

    final credential = FacebookAuthProvider.credential(accessToken.tokenString);

    return _firebaseAuth.signInWithCredential(credential);
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
