import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demix/features/orders/domain/entities/order_entity.dart';

class OrderRemoteDataSource {
  OrderRemoteDataSource({required this._firestore});
  final FirebaseFirestore _firestore;
  Future<String> createOrder(OrderEntity order) async {
    final ref = _firestore.collection('orders').doc();
    await ref.set({
      'orderNumber': order.orderNumber,
      'userId': order.userId,
      'businessId': order.businessId,
      'businessName': order.businessName,
      'items': order.items.map((e) => e.toMap()).toList(),
      'address': order.address.toMap(),
      'subtotal': order.subtotal,
      'deliveryFee': order.deliveryFee,
      'discount': order.discount,
      'total': order.total,
      'paymentMethod': order.paymentMethod,
      'status': order.status,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
    return ref.id;
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> watchOrder(String id) =>
      _firestore.collection('orders').doc(id).snapshots();
  Future<List<DocumentSnapshot<Map<String, dynamic>>>> getMyOrders(
    String userId,
  ) async {
    final q = await _firestore
        .collection('orders')
        .where('userId', isEqualTo: userId)
        .get();
    final docs = [...q.docs]
      ..sort((a, b) {
        final aa = a.data()['createdAt'];
        final bb = b.data()['createdAt'];
        if (aa is Timestamp && bb is Timestamp) return bb.compareTo(aa);
        return 0;
      });
    return docs;
  }
}
