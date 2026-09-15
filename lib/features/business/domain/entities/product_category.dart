import 'package:equatable/equatable.dart';

class ProductCategory extends Equatable {
  const ProductCategory({
    required this.id,
    required this.name,
    this.nameAr,
    this.nameEn,
    this.sortOrder = 0,
    this.isActive = true,
  });

  final String id;
  final String name;
  final String? nameAr;
  final String? nameEn;
  final int sortOrder;
  final bool isActive;

  @override
  List<Object?> get props => [id, name, nameAr, nameEn, sortOrder, isActive];
}
