import 'package:equatable/equatable.dart';
import 'order_item_snapshot.dart';

class DeliveryAddressSnapshot extends Equatable {
  const DeliveryAddressSnapshot({
    required this.formattedAddress,
    required this.street,
    required this.area,
    required this.city,
    required this.latitude,
    required this.longitude,
  });
  final String formattedAddress, street, area, city;
  final double latitude, longitude;
  Map<String, dynamic> toMap() => {
    'formattedAddress': formattedAddress,
    'street': street,
    'area': area,
    'city': city,
    'latitude': latitude,
    'longitude': longitude,
  };
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
    required this.items,
    required this.address,
    required this.subtotal,
    required this.deliveryFee,
    required this.discount,
    required this.total,
    required this.paymentMethod,
    required this.status,
    this.createdAt,
  });
  final String id,
      orderNumber,
      userId,
      businessId,
      businessName,
      paymentMethod,
      status;
  final List<OrderItemSnapshot> items;
  final DeliveryAddressSnapshot address;
  final double subtotal, deliveryFee, discount, total;
  final DateTime? createdAt;
  @override
  List<Object?> get props => [
    id,
    orderNumber,
    userId,
    businessId,
    businessName,
    items,
    address,
    subtotal,
    deliveryFee,
    discount,
    total,
    paymentMethod,
    status,
    createdAt,
  ];
}
