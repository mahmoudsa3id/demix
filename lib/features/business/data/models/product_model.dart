import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demix/features/business/domain/entities/product.dart';

class ProductModel extends Product {
  const ProductModel({
    required super.id,
    required super.businessId,
    required super.name,
    required super.price,
    super.nameAr,
    super.nameEn,
    super.description,
    super.descriptionAr,
    super.descriptionEn,
    super.imageUrl,
    super.categoryId,
    super.isAvailable,
    super.sortOrder,
  });

  factory ProductModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    String businessId,
  ) {
    final data = snapshot.data() ?? <String, dynamic>{};
    return ProductModel(
      id: snapshot.id,
      businessId: _string(data['businessId']).isEmpty ? businessId : _string(data['businessId']),
      name: _string(data['name']),
      price: _double(data['price']),
      nameAr: _nullable(data['nameAr']),
      nameEn: _nullable(data['nameEn']),
      description: _nullable(data['description']),
      descriptionAr: _nullable(data['descriptionAr']),
      descriptionEn: _nullable(data['descriptionEn']),
      imageUrl: _nullable(data['imageUrl']),
      categoryId: _nullable(data['categoryId']),
      isAvailable: data['isAvailable'] as bool? ?? true,
      sortOrder: data['sortOrder'] is num ? (data['sortOrder'] as num).toInt() : 0,
    );
  }

  static String _string(dynamic v) => v?.toString().trim() ?? '';
  static String? _nullable(dynamic v) {
    final s = v?.toString().trim();
    return s == null || s.isEmpty ? null : s;
  }
  static double _double(dynamic v) => v is num ? v.toDouble() : double.tryParse('$v') ?? 0;
}
