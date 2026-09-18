import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demix/features/business/domain/entities/business.dart';
import 'package:demix/features/business/domain/entities/business_page.dart';
import 'package:demix/features/business/domain/entities/product.dart';
import 'package:demix/features/business/domain/entities/product_category.dart';

abstract class BusinessRepository {
  Future<List<Business>> getBusinessesByType(String type);
  Future<Business> getBusinessById(String businessId);
  Future<List<ProductCategory>> getCategories(String businessId);
  Future<List<Product>> getProducts(String businessId, {String? categoryId});
  Future<List<Business>> getAllBusinesses();
  Future<BusinessPage> getBusinessesPage({
    required String type,
    required String languageCode,
    String? search,
    DocumentSnapshot<Map<String, dynamic>>? lastDocument,
    int limit = 10,
  });
}
