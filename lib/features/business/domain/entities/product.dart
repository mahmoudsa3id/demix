import 'package:equatable/equatable.dart';

class Product extends Equatable {
  const Product({
    required this.id,
    required this.businessId,
    required this.name,
    required this.price,
    this.nameAr,
    this.nameEn,
    this.description,
    this.descriptionAr,
    this.descriptionEn,
    this.imageUrl,
    this.categoryId,
    this.isAvailable = true,
    this.sortOrder = 0,
  });

  final String id;
  final String businessId;
  final String name;
  final double price;
  final String? nameAr;
  final String? nameEn;
  final String? description;
  final String? descriptionAr;
  final String? descriptionEn;
  final String? imageUrl;
  final String? categoryId;
  final bool isAvailable;
  final int sortOrder;

  @override
  List<Object?> get props => [
        id, businessId, name, price, nameAr, nameEn, description,
        descriptionAr, descriptionEn, imageUrl, categoryId, isAvailable,
        sortOrder,
      ];
}
