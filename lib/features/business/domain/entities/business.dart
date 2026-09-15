import 'package:equatable/equatable.dart';
import 'working_hours.dart';

class Business extends Equatable {
  const Business({
    required this.id,
    required this.name,
    required this.type,
    this.nameAr,
    this.nameEn,
    this.coverUrl,
    this.logoUrl,
    this.address,
    this.latitude,
    this.longitude,
    this.rating = 0,
    this.reviewCount = 0,
    this.estimatedDeliveryTime = 30,
    this.deliveryFee = 0,
    this.minimumOrder = 0,
    this.isOpen = true,
    this.workingHours,
  });

  final String id;
  final String name;
  final String type;

  final String? nameAr;
  final String? nameEn;

  final String? coverUrl;
  final String? logoUrl;

  final String? address;

  final double? latitude;
  final double? longitude;

  final double rating;
  final int reviewCount;

  final int estimatedDeliveryTime;
  final double deliveryFee;
  final double minimumOrder;

  /// Business manual open/closed status.
  final bool isOpen;

  /// Opening and closing time.
  final WorkingHours? workingHours;

  @override
  List<Object?> get props => [
    id,
    name,
    type,
    nameAr,
    nameEn,
    coverUrl,
    logoUrl,
    address,
    latitude,
    longitude,
    rating,
    reviewCount,
    estimatedDeliveryTime,
    deliveryFee,
    minimumOrder,
    isOpen,
    workingHours,
  ];
}
