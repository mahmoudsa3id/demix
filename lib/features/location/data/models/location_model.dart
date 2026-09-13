import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/location_entity.dart';

class LocationModel extends LocationEntity {
  const LocationModel({
    super.id,
    required super.latitude,
    required super.longitude,
    super.country,
    super.city,
    super.area,
    super.street,
    super.formattedAddress,
    super.zoneId,
    required super.isInsideZone,
    super.createdAt,
    super.updatedAt,
  });

  factory LocationModel.fromEntity(LocationEntity entity) {
    return LocationModel(
      id: entity.id,
      latitude: entity.latitude,
      longitude: entity.longitude,
      country: entity.country,
      city: entity.city,
      area: entity.area,
      street: entity.street,
      formattedAddress: entity.formattedAddress,
      zoneId: entity.zoneId,
      isInsideZone: entity.isInsideZone,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  factory LocationModel.fromSqlMap(Map<String, dynamic> map) {
    DateTime? parse(dynamic value) {
      if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
      if (value is String) return DateTime.tryParse(value);
      return null;
    }

    return LocationModel(
      id: (map['id'] as num?)?.toInt() ?? 1,
      latitude: (map['latitude'] as num).toDouble(),
      longitude: (map['longitude'] as num).toDouble(),
      country: map['country'] as String?,
      city: map['city'] as String?,
      area: map['area'] as String?,
      street: map['street'] as String?,
      formattedAddress: map['formatted_address'] as String?,
      zoneId: map['zone_id'] as String?,
      isInsideZone: ((map['is_inside_zone'] as num?)?.toInt() ?? 0) == 1,
      createdAt: parse(map['created_at']),
      updatedAt: parse(map['updated_at']),
    );
  }

  factory LocationModel.fromFirestore(
    Map<String, dynamic> data, {
    int id = 1,
  }) {
    DateTime? parse(dynamic value) {
      if (value is Timestamp) return value.toDate();
      if (value is DateTime) return value;
      if (value is String) return DateTime.tryParse(value);
      return null;
    }

    return LocationModel(
      id: id,
      latitude: (data['latitude'] as num).toDouble(),
      longitude: (data['longitude'] as num).toDouble(),
      country: data['country'] as String?,
      city: data['city'] as String?,
      area: data['area'] as String?,
      street: data['street'] as String?,
      formattedAddress: data['formattedAddress'] as String?,
      zoneId: data['zoneId'] as String?,
      isInsideZone: data['isInsideZone'] == true,
      createdAt: parse(data['createdAt']),
      updatedAt: parse(data['updatedAt']),
    );
  }

  Map<String, dynamic> toSqlMap() {
    return {
      'id': id,
      'latitude': latitude,
      'longitude': longitude,
      'country': country,
      'city': city,
      'area': area,
      'street': street,
      'formatted_address': formattedAddress,
      'zone_id': zoneId,
      'is_inside_zone': isInsideZone ? 1 : 0,
      'created_at': createdAt?.millisecondsSinceEpoch,
      'updated_at': updatedAt?.millisecondsSinceEpoch,
    };
  }

  Map<String, dynamic> toFirestoreMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'country': country,
      'city': city,
      'area': area,
      'street': street,
      'formattedAddress': formattedAddress,
      'zoneId': zoneId,
      'isInsideZone': isInsideZone,
    };
  }
}
