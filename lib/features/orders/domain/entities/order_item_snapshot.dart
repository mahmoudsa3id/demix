import 'package:equatable/equatable.dart';

class OrderItemSnapshot extends Equatable {
  const OrderItemSnapshot({
    required this.productId,
    required this.businessLogo,
    required this.businessId,
    required this.categoryId,
    required this.name,
    required this.nameAr,
    required this.imageUrl,
    required this.quantity,
    required this.unitPrice,
    required this.lineTotal,
  });

  final String productId;
  final String businessLogo;
  final String businessId;
  final String categoryId;
  final String name;
  final String? nameAr;
  final String? imageUrl;
  final int quantity;
  final double unitPrice;
  final double lineTotal;

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'businessLogo': businessLogo,
      'businessId': businessId,
      'categoryId': categoryId,
      'name': name,
      'nameAr': nameAr,
      'imageUrl': imageUrl,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'lineTotal': lineTotal,
    };
  }

  factory OrderItemSnapshot.fromMap(Map<String, dynamic> map) {
    return OrderItemSnapshot(
      productId: map['productId']?.toString() ?? '',
      businessLogo: map['businessLogo']?.toString() ?? '',
      businessId: map['businessId']?.toString() ?? '',
      categoryId: map['categoryId']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      nameAr: map['nameAr']?.toString(),
      imageUrl: map['imageUrl']?.toString(),
      quantity: _toInt(map['quantity']),
      unitPrice: _toDouble(map['unitPrice']),
      lineTotal: _toDouble(map['lineTotal']),
    );
  }

  static int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();

    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static double _toDouble(dynamic value) {
    if (value is num) return value.toDouble();

    return double.tryParse(value?.toString() ?? '') ?? 0.0;
  }

  @override
  List<Object?> get props => [
    productId,
    businessLogo,
    businessId,
    categoryId,
    name,
    nameAr,
    imageUrl,
    quantity,
    unitPrice,
    lineTotal,
  ];
}
