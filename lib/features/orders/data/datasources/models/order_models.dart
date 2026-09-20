import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demix/features/orders/domain/entities/order_entity.dart';
import 'package:demix/features/orders/domain/entities/order_item_snapshot.dart';

class OrderModel extends OrderEntity {
  const OrderModel({
    required super.id,
    required super.orderNumber,
    required super.userId,
    required super.businessId,
    required super.businessName,
    super.businessImageUrl,
    required super.items,
    required super.address,
    required super.subtotal,
    required super.deliveryFee,
    required super.discount,
    required super.total,
    required super.paymentMethod,
    required super.status,
    required super.createdAt,
  });

  factory OrderModel.fromFirebase(
    Map<String, dynamic> data, {
    required String id,
  }) {
    final rawItems = data['items'] as List<dynamic>? ?? [];

    final items = rawItems
        .whereType<Map>()
        .map(
          (item) => OrderItemSnapshot.fromMap(Map<String, dynamic>.from(item)),
        )
        .toList();

    final rawAddress = data['address'];

    final address = rawAddress is Map
        ? DeliveryAddressSnapshot.fromMap(Map<String, dynamic>.from(rawAddress))
        : const DeliveryAddressSnapshot(
            formattedAddress: '',
            street: '',
            area: '',
            city: '',
            latitude: 0,
            longitude: 0,
          );

    return OrderModel(
      id: id,
      orderNumber: data['orderNumber']?.toString() ?? '',
      userId: data['userId']?.toString() ?? '',
      businessId: data['businessId']?.toString() ?? '',
      businessName: data['businessName']?.toString() ?? '',
      businessImageUrl: data['businessImageUrl']?.toString(),
      items: items,
      address: address,
      subtotal: _toDouble(data['subtotal']),
      deliveryFee: _toDouble(data['deliveryFee']),
      discount: _toDouble(data['discount']),
      total: _toDouble(data['total']),
      paymentMethod: data['paymentMethod']?.toString() ?? '',
      status: data['status']?.toString() ?? '',
      createdAt: _parseDateTime(data['createdAt']),
    );
  }

  Map<String, dynamic> toFirebase() {
    return {
      'orderNumber': orderNumber,
      'userId': userId,
      'businessId': businessId,
      'businessName': businessName,
      'businessImageUrl': businessImageUrl,
      'items': items.map((item) => item.toMap()).toList(),
      'address': address.toMap(),
      'subtotal': subtotal,
      'deliveryFee': deliveryFee,
      'discount': discount,
      'total': total,
      'paymentMethod': paymentMethod,
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  static double _toDouble(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }

  static DateTime _parseDateTime(dynamic value) {
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    if (value is String) {
      return DateTime.tryParse(value) ?? DateTime.now();
    }
    return DateTime.now();
  }
}
