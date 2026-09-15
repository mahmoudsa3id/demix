import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demix/features/business/domain/entities/business.dart';

import 'working_hours_model.dart';

class BusinessModel extends Business {
  const BusinessModel({
    required super.id,
    required super.name,
    required super.type,
    super.nameAr,
    super.nameEn,
    super.coverUrl,
    super.logoUrl,
    super.address,
    super.latitude,
    super.longitude,
    super.rating,
    super.reviewCount,
    super.estimatedDeliveryTime,
    super.deliveryFee,
    super.minimumOrder,
    super.isOpen,
    super.workingHours,
  });

  factory BusinessModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data() ?? <String, dynamic>{};

    return BusinessModel(
      id: snapshot.id,
      name: _string(data['name']),
      type: _string(data['type']).toLowerCase(),

      nameAr: _nullableString(data['nameAr']),
      nameEn: _nullableString(data['nameEn']),

      coverUrl: _nullableString(data['coverUrl']),
      logoUrl: _nullableString(data['logoUrl']),

      address: _nullableString(data['address']),

      latitude: _nullableDouble(data['latitude']),
      longitude: _nullableDouble(data['longitude']),

      rating: _double(data['rating']),
      reviewCount: _int(data['reviewCount']),

      estimatedDeliveryTime: _int(data['estimatedDeliveryTime'], fallback: 30),

      deliveryFee: _double(data['deliveryFee']),
      minimumOrder: _double(data['minimumOrder']),

      isOpen: data['isOpen'] is bool ? data['isOpen'] as bool : true,

      workingHours: _workingHours(data['workingHours']),
    );
  }

  static WorkingHoursModel? _workingHours(dynamic value) {
    if (value is! Map) return null;

    return WorkingHoursModel.fromMap(Map<String, dynamic>.from(value));
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'type': type,

      'nameAr': nameAr,
      'nameEn': nameEn,

      'coverUrl': coverUrl,
      'logoUrl': logoUrl,

      'address': address,

      'latitude': latitude,
      'longitude': longitude,

      'rating': rating,
      'reviewCount': reviewCount,

      'estimatedDeliveryTime': estimatedDeliveryTime,
      'deliveryFee': deliveryFee,
      'minimumOrder': minimumOrder,

      'isOpen': isOpen,

      'workingHours': workingHours == null
          ? null
          : WorkingHoursModel(
              open: workingHours!.open,
              close: workingHours!.close,
            ).toMap(),
    };
  }

  static String _string(dynamic value) {
    return value?.toString().trim() ?? '';
  }

  static String? _nullableString(dynamic value) {
    final valueString = value?.toString().trim();

    if (valueString == null || valueString.isEmpty) {
      return null;
    }

    return valueString;
  }

  static double _double(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse('$value') ?? 0;
  }

  static double? _nullableDouble(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse('$value');
  }

  static int _int(dynamic value, {int fallback = 0}) {
    if (value is num) {
      return value.toInt();
    }

    return int.tryParse('$value') ?? fallback;
  }
}
