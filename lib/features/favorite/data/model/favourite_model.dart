import 'package:demix/features/favorite/domain/entities/favourite_entity.dart';

class FavoriteModel extends FavoriteEntity {
  const FavoriteModel({
    required super.id,
    required super.type,
    required super.itemId,
    required super.name,
    super.nameAr,
    super.imageUrl,
    super.coverUrl,
    super.logoUrl,
    super.rating,
    super.reviewCount,
    super.price,
    super.businessId,
    super.businessName,
    super.businessLogo,
    super.businessRating,
  });

  factory FavoriteModel.fromMap(Map<String, dynamic> map) {
    return FavoriteModel(
      id: map['favorite_id']?.toString() ?? '',
      type: FavoriteType.fromString(map['type']?.toString()),
      itemId: map['item_id']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      nameAr: _nullableString(map['name_ar']),
      imageUrl: _nullableString(map['image_url']),
      coverUrl: _nullableString(map['cover_url']),
      logoUrl: _nullableString(map['logo_url']),
      rating: _nullableDouble(map['rating']),
      reviewCount: _nullableInt(map['review_count']),
      price: _nullableDouble(map['price']),
      businessId: _nullableString(map['business_id']),
      businessName: _nullableString(map['business_name']),
      businessLogo: _nullableString(map['business_logo']),
      businessRating: _nullableDouble(map['business_rating']),
    );
  }

  Map<String, dynamic> toMap({required String userId}) {
    return {
      'favorite_id': id,
      'user_id': userId,

      'type': type.value,
      'item_id': itemId,

      'name': name,
      'name_ar': nameAr,

      'image_url': imageUrl,

      'cover_url': coverUrl,
      'logo_url': logoUrl,

      'rating': rating,
      'review_count': reviewCount,

      'price': price,

      'business_id': businessId,
      'business_name': businessName,
      'business_logo': businessLogo,
      'business_rating': businessRating,

      'created_at': DateTime.now().millisecondsSinceEpoch,
    };
  }

  static String? _nullableString(dynamic value) {
    final result = value?.toString().trim();

    if (result == null || result.isEmpty) {
      return null;
    }

    return result;
  }

  static double? _nullableDouble(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(value?.toString() ?? '');
  }

  static int? _nullableInt(dynamic value) {
    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(value?.toString() ?? '');
  }
}
