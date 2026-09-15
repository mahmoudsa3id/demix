import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demix/features/business/data/datasources/business_remote_data_source.dart';
import 'package:demix/features/business/domain/entities/business.dart';
import 'package:demix/features/business/domain/entities/business_page.dart';
import 'package:demix/features/business/domain/entities/product.dart';
import 'package:demix/features/business/domain/entities/product_category.dart';
import 'package:demix/features/business/domain/repositories/business_repository.dart';

class BusinessRepositoryImpl implements BusinessRepository {
  BusinessRepositoryImpl({required BusinessRemoteDataSource remoteDataSource})
    : _remote = remoteDataSource;

  final BusinessRemoteDataSource _remote;

  @override
  Future<List<Business>> getBusinessesByType(String type) =>
      _remote.getBusinessesByType(type);
  @override
  Future<List<Business>> getAllBusinesses() => _remote.getAllBusinesses();
  @override
  Future<BusinessPage> getBusinessesPage({
    required String type,
    required String languageCode,
    String? search,
    DocumentSnapshot<Map<String, dynamic>>? lastDocument,
    int limit = 10,
  }) {
    return _remote.getBusinessesPage(
      type: type,
      languageCode: languageCode,
      search: search,
      lastDocument: lastDocument,
      limit: limit,
    );
  }

  @override
  Future<Business> getBusinessById(String businessId) =>
      _remote.getBusinessById(businessId);

  @override
  Future<List<ProductCategory>> getCategories(String businessId) =>
      _remote.getCategories(businessId);

  @override
  Future<List<Product>> getProducts(String businessId, {String? categoryId}) =>
      _remote.getProducts(businessId, categoryId: categoryId);
}
