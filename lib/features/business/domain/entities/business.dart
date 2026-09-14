class Business {
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

  final String id;
  final String name;
  final String? nameAr;
  final String? nameEn;
  final String? coverUrl;
  final String? logoUrl;

  /// Expected values:
  /// restaurant
  /// cafe
  final String type;

  final double rating;
  final int reviewCount;
  final int estimatedDeliveryTime;
  final double deliveryFee;
  final double minimumOrder;

  String displayName({required bool isArabic}) {
    if (isArabic &&
        nameAr != null &&
        nameAr!.trim().isNotEmpty) {
      return nameAr!.trim();
    }

    if (!isArabic &&
        nameEn != null &&
        nameEn!.trim().isNotEmpty) {
      return nameEn!.trim();
    }

    return name;
  }
}
