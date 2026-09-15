import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demix/features/business/domain/entities/product_category.dart';

class ProductCategoryModel extends ProductCategory {
  const ProductCategoryModel({
    required super.id,
    required super.name,
    super.nameAr,
    super.nameEn,
    super.sortOrder,
    super.isActive,
  });

  factory ProductCategoryModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data() ?? <String, dynamic>{};
    return ProductCategoryModel(
      id: snapshot.id,
      name: data['name']?.toString() ?? '',
      nameAr: data['nameAr']?.toString(),
      nameEn: data['nameEn']?.toString(),
      sortOrder: data['sortOrder'] is num ? (data['sortOrder'] as num).toInt() : 0,
      isActive: data['isActive'] as bool? ?? true,
    );
  }
}
