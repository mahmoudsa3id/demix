class Business {
  final String id;
  final String name;
  final String? nameAr;
  final String? nameEn;
  final String? coverUrl;
  final String? logoUrl;
  final String type;
  final double rating;
  final int reviewCount;
  final int estimatedDeliveryTime;
  final double deliveryFee;
  final double minimumOrder;

  const Business({
    required this.id,
    required this.name,
    this.nameAr,
    this.nameEn,
    this.coverUrl,
    this.logoUrl,
    required this.type,
    required this.rating,
    required this.reviewCount,
    required this.estimatedDeliveryTime,
    required this.deliveryFee,
    required this.minimumOrder,
  });
}
