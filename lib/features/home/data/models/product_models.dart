class ProductModel {
  const ProductModel({
    this.id,
    this.businessId,
    required this.name,
    required this.imageUrl,
    required this.rating,
    required this.deliveryTime,
    required this.deliveryPrice,
    required this.price,
    required this.discount,
    this.isPro = false,
    this.nameEn,
    this.deliveryTimeEn,
    this.deliveryPriceEn,
    this.discountEn,
  });

  final String? id;
  final String? businessId;
  final String name;
  final String imageUrl;
  final double rating;
  final String deliveryTime;
  final String deliveryPrice;
  final double price;
  final String discount;
  final bool isPro;
  final String? nameEn;
  final String? deliveryTimeEn;
  final String? deliveryPriceEn;
  final String? discountEn;
}
