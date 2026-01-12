import 'package:cloud_firestore/cloud_firestore.dart';

class OrderRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static const String _collection = 'bookings';
  Future<String> createOrder(Map<String, dynamic> data) async {
    final docRef = await _firestore
        .collection(_collection)
        .add(data);

    return docRef.id;
  }
  Stream<DocumentSnapshot<Map<String, dynamic>>> streamOrder(
    String orderId,
  ) {
    return _firestore
        .collection(_collection)
        .doc(orderId)
        .snapshots();
  }
  Stream<QuerySnapshot<Map<String, dynamic>>> streamOrdersByUser(
    String userId,
  ) {
    return _firestore
        .collection(_collection)
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }
  
  Future<void> updateOrder(
    String orderId,
    Map<String, dynamic> data,
  ) async {
    await _firestore
        .collection(_collection)
        .doc(orderId)
        .update(data);
  }

  Future<void> deleteOrder(String orderId) async {
    await _firestore
        .collection(_collection)
        .doc(orderId)
        .delete();
  }
}
