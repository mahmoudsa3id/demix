import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../models/location_model.dart';

class LocationFirestoreDataSource {
  LocationFirestoreDataSource({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  DocumentReference<Map<String, dynamic>> _reference() {
    final uid = _auth.currentUser?.uid;
    if (uid == null || uid.isEmpty) {
      throw const LocationUnauthenticatedException();
    }

    return _firestore
        .collection('users')
        .doc(uid)
        .collection('location')
        .doc('current');
  }

  Future<void> createOrReplace(LocationModel model) async {
    await _reference().set(
      {
        ...model.toFirestoreMap(),
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }

  Future<LocationModel?> readCurrent() async {
    final snapshot = await _reference().get();
    if (!snapshot.exists || snapshot.data() == null) return null;
    return LocationModel.fromFirestore(snapshot.data()!);
  }

  Future<void> updateCurrent(LocationModel model) async {
    await _reference().update({
      ...model.toFirestoreMap(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteCurrent() => _reference().delete();
}

class LocationUnauthenticatedException implements Exception {
  const LocationUnauthenticatedException();
}
