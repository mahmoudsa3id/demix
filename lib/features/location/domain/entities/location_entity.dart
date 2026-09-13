class LocationEntity {
  const LocationEntity({
    this.id = 1,
    required this.latitude,
    required this.longitude,
    this.country,
    this.city,
    this.area,
    this.street,
    this.formattedAddress,
    this.zoneId,
    required this.isInsideZone,
    this.createdAt,
    this.updatedAt,
  });

  final int id;
  final double latitude;
  final double longitude;
  final String? country;
  final String? city;
  final String? area;
  final String? street;
  final String? formattedAddress;
  final String? zoneId;
  final bool isInsideZone;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  LocationEntity copyWith({
    int? id,
    double? latitude,
    double? longitude,
    String? country,
    String? city,
    String? area,
    String? street,
    String? formattedAddress,
    String? zoneId,
    bool? isInsideZone,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return LocationEntity(
      id: id ?? this.id,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      country: country ?? this.country,
      city: city ?? this.city,
      area: area ?? this.area,
      street: street ?? this.street,
      formattedAddress: formattedAddress ?? this.formattedAddress,
      zoneId: zoneId ?? this.zoneId,
      isInsideZone: isInsideZone ?? this.isInsideZone,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
