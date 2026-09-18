import 'package:demix/features/orders/domain/entities/order_entity.dart';

class OrderModels extends OrderEntity {
  const OrderModels({
    required super.id,
    required super.orderNumber,
    required super.userId,
    required super.businessId,
    required super.businessName,
    required super.items,
    required super.address,
    required super.subtotal,
    required super.deliveryFee,
    required super.discount,
    required super.total,
    required super.paymentMethod,
    required super.status,
  });
  factory OrderModels.formFirebase(Map<String, dynamic> data) {
    return OrderModels(
      id: data['id'],
      orderNumber: data['orderNumber'],
      userId: data['userId'],
      businessId: data['businessId'],
      businessName: data['businessName'],
      items: data['items'],
      address: data['address']?['formattedAddress'] ?? '',
      subtotal: data['subtotal'],
      deliveryFee: data['deliveryFee'],
      discount: data['discount'],
      total: data['total'],
      paymentMethod: data['paymentMethod'],
      status: data['status'],
    );
  }
}
