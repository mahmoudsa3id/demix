import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demix/features/business/data/models/business_model.dart';
import 'package:demix/features/business/data/models/product_category_model.dart';
import 'package:demix/features/business/data/models/product_model.dart';

import 'package:demix/features/business/domain/entities/business_page.dart';

abstract class BusinessRemoteDataSource {
  Future<List<BusinessModel>> getBusinessesByType(String type);

  Future<List<BusinessModel>> getAllBusinesses();

  Future<BusinessModel> getBusinessById(String businessId);

  Future<List<ProductCategoryModel>> getCategories(String businessId);

  Future<List<ProductModel>> getProducts(
    String businessId, {
    String? categoryId,
  });

  Future<BusinessPage> getBusinessesPage({
    required String type,
    required String languageCode,
    String? search,
    DocumentSnapshot<Map<String, dynamic>>? lastDocument,
    int limit = 10,
  });
}

class FirebaseBusinessRemoteDataSource implements BusinessRemoteDataSource {
  FirebaseBusinessRemoteDataSource({required this._firestore});

  final FirebaseFirestore _firestore;
  @override
  Future<BusinessPage> getBusinessesPage({
    required String type,
    required String languageCode,
    String? search,
    DocumentSnapshot<Map<String, dynamic>>? lastDocument,
    int limit = 10,
  }) async {
    final normalizedType = type.trim().toLowerCase();
    final normalizedSearch = search?.trim();

    Query<Map<String, dynamic>> query = _firestore
        .collection('businesses')
        .where('type', isEqualTo: normalizedType);

    final hasSearch = normalizedSearch != null && normalizedSearch.isNotEmpty;

    if (hasSearch) {
      final searchField = languageCode == 'ar' ? 'nameAr' : 'nameEn';

      query = query.orderBy(searchField).startAt([normalizedSearch]).endAt([
        '$normalizedSearch\uf8ff',
      ]);
    } else {
      query = query.orderBy('rating', descending: true);
    }

    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument);
    }

    final snapshot = await query.limit(limit).get();

    final businesses = snapshot.docs.map(BusinessModel.fromFirestore).toList();

    return BusinessPage(
      businesses: businesses,
      lastDocument: snapshot.docs.isEmpty ? lastDocument : snapshot.docs.last,
      hasMore: snapshot.docs.length == limit,
    );
  }

  @override
  Future<List<BusinessModel>> getBusinessesByType(String type) async {
    final snapshot = await _firestore
        .collection('businesses')
        .where('type', isEqualTo: type.trim().toLowerCase())
        .get();

    final result = snapshot.docs.map(BusinessModel.fromFirestore).toList();
    result.sort((a, b) => b.rating.compareTo(a.rating));
    return result;
  }

  @override
  Future<BusinessModel> getBusinessById(String businessId) async {
    final snapshot = await _firestore
        .collection('businesses')
        .doc(businessId)
        .get();
    if (!snapshot.exists) {
      throw StateError('Business not found');
    }
    return BusinessModel.fromFirestore(snapshot);
  }

  @override
  Future<List<BusinessModel>> getAllBusinesses() async {
    final snapshot = await _firestore.collection('businesses').get();

    final result = snapshot.docs.map(BusinessModel.fromFirestore).toList();

    result.sort((a, b) => b.rating.compareTo(a.rating));

    return result;
  }

  @override
  Future<List<ProductCategoryModel>> getCategories(String businessId) async {
    final snapshot = await _firestore
        .collection('businesses')
        .doc(businessId)
        .collection('categories')
        .where('isActive', isEqualTo: true)
        .get();

    final result = snapshot.docs
        .map(ProductCategoryModel.fromFirestore)
        .toList();
    result.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    return result;
  }

  @override
  Future<List<ProductModel>> getProducts(
    String businessId, {
    String? categoryId,
  }) async {
    Query<Map<String, dynamic>> query = _firestore
        .collection('businesses')
        .doc(businessId)
        .collection('products')
        .where('isAvailable', isEqualTo: true);

    if (categoryId != null && categoryId.trim().isNotEmpty) {
      query = query.where('categoryId', isEqualTo: categoryId);
    }

    final snapshot = await query.get();
    final result = snapshot.docs
        .map((doc) => ProductModel.fromFirestore(doc, businessId))
        .toList();
    result.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    return result;
  }
}
