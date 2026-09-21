import 'package:demix/features/orders/domain/entities/order_item_snapshot.dart';
import 'package:equatable/equatable.dart';

class DeliveryAddressSnapshot extends Equatable {
  const DeliveryAddressSnapshot({
    required this.formattedAddress,
    required this.street,
    required this.area,
    required this.city,
    required this.latitude,
    required this.longitude,
  });

  final String formattedAddress;
  final String street;
  final String area;
  final String city;
  final double latitude;
  final double longitude;

  Map<String, dynamic> toMap() {
    return {
      'formattedAddress': formattedAddress,
      'street': street,
      'area': area,
      'city': city,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory DeliveryAddressSnapshot.fromMap(Map<String, dynamic> map) {
    return DeliveryAddressSnapshot(
      formattedAddress: map['formattedAddress']?.toString() ?? '',
      street: map['street']?.toString() ?? '',
      area: map['area']?.toString() ?? '',
      city: map['city']?.toString() ?? '',
      latitude: _toDouble(map['latitude']),
      longitude: _toDouble(map['longitude']),
    );
  }

  static double _toDouble(dynamic value) {
    if (value is num) return value.toDouble();

    return double.tryParse(value?.toString() ?? '') ?? 0.0;
  }

  @override
  List<Object?> get props => [
    formattedAddress,
    street,
    area,
    city,
    latitude,
    longitude,
  ];
}

class OrderEntity extends Equatable {
  const OrderEntity({
    required this.id,
    required this.orderNumber,
    required this.userId,
    required this.businessId,
    required this.businessName,
    this.businessImageUrl,
    required this.items,
    required this.address,
    required this.customerName,
    required this.customerPhone,
    this.addressDetails,
    required this.subtotal,
    required this.deliveryFee,
    required this.discount,
    required this.total,
    required this.paymentMethod,
    required this.status,
    required this.createdAt,
  });

  final String id;
  final String orderNumber;
  final String userId;

  final String businessId;
  final String businessName;
  final String? businessImageUrl;

  final List<OrderItemSnapshot> items;

  final DeliveryAddressSnapshot address;

  final String customerName;
  final String customerPhone;
  final String? addressDetails;

  final double subtotal;
  final double deliveryFee;
  final double discount;
  final double total;

  final String paymentMethod;
  final String status;
  final DateTime createdAt;

  @override
  List<Object?> get props => [
    id,
    orderNumber,
    userId,
    businessId,
    businessName,
    businessImageUrl,
    items,
    address,
    customerName,
    customerPhone,
    addressDetails,
    subtotal,
    deliveryFee,
    discount,
    total,
    paymentMethod,
    status,
    createdAt,
  ];
}
