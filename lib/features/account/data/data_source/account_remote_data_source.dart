import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demix/features/account/data/model/account_user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AccountRemoteDataSource {
  Future<AccountUserModel> getCurrentUser();

  Future<AccountUserModel> updateProfile({
    required String displayName,
    String? phone,
  });

  Future<void> deleteAccount();
}

class FirebaseAccountRemoteDataSource implements AccountRemoteDataSource {
  FirebaseAccountRemoteDataSource({
    FirebaseFirestore? firestore,
    FirebaseAuth? firebaseAuth,
  }) : _firestore = firestore ?? FirebaseFirestore.instance,
       _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;

  CollectionReference<Map<String, dynamic>> get _users =>
      _firestore.collection('users');

  User get _currentUser {
    final user = _firebaseAuth.currentUser;

    if (user == null) {
      throw FirebaseAuthException(
        code: 'user-not-found',
        message: 'No authenticated user found.',
      );
    }

    return user;
  }

  @override
  Future<AccountUserModel> getCurrentUser() async {
    final user = _currentUser;

    final snapshot = await _users.doc(user.uid).get();

    if (snapshot.exists) {
      return AccountUserModel.fromFirestore(snapshot);
    }

    return AccountUserModel(
      id: user.uid,
      displayName: user.displayName,
      email: user.email,
      phone: user.phoneNumber,
      avatarUrl: user.photoURL,
    );
  }

  @override
  Future<AccountUserModel> updateProfile({
    required String displayName,
    String? phone,
  }) async {
    final user = _currentUser;

    final trimmedName = displayName.trim();
    final trimmedPhone = phone?.trim();

    await user.updateDisplayName(trimmedName);

    await user.reload();

    final updatedFirebaseUser = _firebaseAuth.currentUser;

    if (updatedFirebaseUser == null) {
      throw FirebaseAuthException(
        code: 'user-not-found',
        message: 'User no longer exists.',
      );
    }

    await _users.doc(user.uid).set({
      'displayName': trimmedName,
      'email': updatedFirebaseUser.email,
      'phone': trimmedPhone,
      'avatarUrl': updatedFirebaseUser.photoURL,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    return AccountUserModel(
      id: updatedFirebaseUser.uid,
      displayName: trimmedName,
      email: updatedFirebaseUser.email,
      phone: trimmedPhone,
      avatarUrl: updatedFirebaseUser.photoURL,
    );
  }

  @override
  Future<void> deleteAccount() async {
    final user = _currentUser;

    await _users.doc(user.uid).delete();

    await user.delete();
  }
}
