import 'package:equatable/equatable.dart';

import 'package:demix/features/business/domain/entities/business.dart';
import 'package:demix/features/business/domain/entities/product.dart';

enum FavoriteType {
  restaurant,
  cafe,
  product;

  String get value => name;

  static FavoriteType fromString(String? value) {
    switch (value?.trim().toLowerCase()) {
      case 'cafe':
      case 'coffee':
      case 'coffee_shop':
      case 'cafes':
        return FavoriteType.cafe;

      case 'product':
        return FavoriteType.product;

      case 'restaurant':
      case 'restaurants':
      default:
        return FavoriteType.restaurant;
    }
  }
}

class FavoriteEntity extends Equatable {
  const FavoriteEntity({
    required this.id,
    required this.type,
    required this.itemId,
    required this.name,
    this.nameAr,
    this.imageUrl,
    this.coverUrl,
    this.logoUrl,
    this.rating,
    this.reviewCount,
    this.price,
    this.businessId,
    this.businessName,
    this.businessLogo,
    this.businessRating,
  });

  final String id;
  final FavoriteType type;
  final String itemId;

  final String name;
  final String? nameAr;

  /// Product image
  final String? imageUrl;

  /// Business cover
  final String? coverUrl;

  /// Business logo
  final String? logoUrl;

  final double? rating;
  final int? reviewCount;

  /// Product price
  final double? price;

  /// Product -> Business
  final String? businessId;
  final String? businessName;
  final String? businessLogo;
  final double? businessRating;

  String get displayName {
    if (nameAr != null && nameAr!.trim().isNotEmpty) {
      return nameAr!.trim();
    }

    return name.trim();
  }

  factory FavoriteEntity.fromBusiness(Business business) {
    final typeValue = business.type.trim().toLowerCase();

    final type = typeValue.contains('cafe') || typeValue.contains('coffee')
        ? FavoriteType.cafe
        : FavoriteType.restaurant;

    return FavoriteEntity(
      id: '${type.value}_${business.id}',
      type: type,
      itemId: business.id,
      name: business.name,
      nameAr: business.nameAr,
      coverUrl: business.coverUrl,
      logoUrl: business.logoUrl,
      rating: business.rating,
      reviewCount: business.reviewCount,
    );
  }

  factory FavoriteEntity.fromProduct(
    Product product, {
    String? businessName,
    double? businessRating,
  }) {
    return FavoriteEntity(
      id: 'product_${product.id}',
      type: FavoriteType.product,
      itemId: product.id,
      name: product.name,
      nameAr: product.nameAr,
      imageUrl: product.imageUrl,
      price: product.price,
      businessId: product.businessId,
      businessName: businessName,
      businessLogo: product.businessLogo,
      businessRating: businessRating,
    );
  }

  @override
  List<Object?> get props => [
    id,
    type,
    itemId,
    name,
    nameAr,
    imageUrl,
    coverUrl,
    logoUrl,
    rating,
    reviewCount,
    price,
    businessId,
    businessName,
    businessLogo,
    businessRating,
  ];
}
