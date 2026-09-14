import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/business_model.dart';

class BusinessRemoteDataSource {
  BusinessRemoteDataSource({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  final FirebaseFirestore _firestore;

  Future<List<BusinessModel>> getBusinessesByType(
    String type,
  ) async {
    final normalizedType =
        type.trim().toLowerCase();

    final snapshot = await _firestore
        .collection('businesses')
        .where(
          'type',
          isEqualTo: normalizedType,
        )
        .get();

    final businesses = snapshot.docs
        .map(BusinessModel.fromFirestore)
        .where(
          (business) =>
              business.type == normalizedType,
        )
        .toList();

    // Higher rated businesses first.
    businesses.sort(
      (a, b) => b.rating.compareTo(a.rating),
    );

    return businesses;
  }
}
