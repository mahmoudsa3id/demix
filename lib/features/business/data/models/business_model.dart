import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/business.dart';

class BusinessModel extends Business {
  const BusinessModel({
    required super.id,
    required super.name,
    super.nameAr,
    super.nameEn,
    super.coverUrl,
    super.logoUrl,
    required super.type,
    required super.rating,
    required super.reviewCount,
    required super.estimatedDeliveryTime,
    required super.deliveryFee,
    required super.minimumOrder,
  });

  factory BusinessModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data =
        document.data() ?? const <String, dynamic>{};

    return BusinessModel(
      id: document.id,
      name: _string(data['name']) ?? 'Business',
      nameAr: _string(data['nameAr']),
      nameEn: _string(data['nameEn']),
      coverUrl: _string(data['coverUrl']),
      logoUrl: _string(data['logoUrl']),
      type: (_string(data['type']) ?? '').toLowerCase(),
      rating: _double(data['rating']),
      reviewCount: _int(data['reviewCount']),
      estimatedDeliveryTime:
          _int(data['estimatedDeliveryTime']),
      deliveryFee: _double(data['deliveryFee']),
      minimumOrder: _double(data['minimumOrder']),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'nameAr': nameAr,
      'nameEn': nameEn,
      'coverUrl': coverUrl,
      'logoUrl': logoUrl,
      'type': type,
      'rating': rating,
      'reviewCount': reviewCount,
      'estimatedDeliveryTime':
          estimatedDeliveryTime,
      'deliveryFee': deliveryFee,
      'minimumOrder': minimumOrder,
    };
  }

  static String? _string(dynamic value) {
    if (value is String && value.trim().isNotEmpty) {
      return value.trim();
    }
    return null;
  }

  static double _double(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }

    if (value is String) {
      return double.tryParse(value) ?? 0;
    }

    return 0;
  }

  static int _int(dynamic value) {
    if (value is num) {
      return value.toInt();
    }

    if (value is String) {
      return int.tryParse(value) ?? 0;
    }

    return 0;
  }
}
