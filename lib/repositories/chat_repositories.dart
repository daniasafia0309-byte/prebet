import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prebet/data/chat_model.dart';

class ChatRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _chatRef =>
      _firestore.collection('chats');

  // ================= CREATE CHAT =================

  Future<void> createChatIfNotExists({
    required String orderId,
    required String userId,
    required String driverId,
    required bool isSupportChat,
    String? driverName,
    int? driverAvatarColor,
  }) async {
    final docRef = _chatRef.doc(orderId);
    final snap = await docRef.get();

    if (!snap.exists) {
      await docRef.set({
        'orderId': orderId,
        'userId': userId, // ✅ penting untuk logik chat
        'driverId': driverId,
        'driverName': driverName ?? 'Driver',
        'driverAvatarColor': driverAvatarColor ?? 0xFF0D7C7B,
        'participants': [userId, driverId], // ✅ WAJIB
        'lastMessage': '', // ✅ ChatPage tapis guna ini
        'lastSenderId': '',
        'type': isSupportChat ? 'support' : 'ride',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }
  }

  // ================= SEND MESSAGE =================

  Future<void> sendMessage({
    required String orderId,
    required ChatModel message,
  }) async {
    final chatDoc = _chatRef.doc(orderId);

    // ✅ SIMPAN MESSAGE (IKUT STRUKTUR DB)
    await chatDoc.collection('messages').add({
      'text': message.message,
      'senderId': message.senderId,
      'receiverId': message.receiverId,
      'createdAt': FieldValue.serverTimestamp(),
      'isRead': message.isRead,
    });

    // ✅ UPDATE CHAT LIST (INI YANG BUAT CHAT NAIK)
    await chatDoc.update({
      'lastMessage': message.message,
      'lastSenderId': message.senderId,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // ================= STREAM MESSAGES =================

  Stream<List<ChatModel>> streamMessages(String orderId) {
    return _chatRef
        .doc(orderId)
        .collection('messages')
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => ChatModel.fromDocument(doc))
              .toList(),
        );
  }

  // ================= STREAM USER CHATS =================

  Stream<QuerySnapshot<Map<String, dynamic>>> streamUserChats(
      String userId) {
    return _chatRef
        .where('participants', arrayContains: userId)
        .orderBy('updatedAt', descending: true)
        .snapshots();
  }

  // ================= MARK READ =================

  Future<void> markMessageAsRead({
    required String orderId,
    required String messageId,
  }) async {
    await _chatRef
        .doc(orderId)
        .collection('messages')
        .doc(messageId)
        .update({'isRead': true});
  }

  // ================= DELETE CHAT =================

  Future<void> deleteChat(String orderId) async {
    final messages =
        await _chatRef.doc(orderId).collection('messages').get();

    for (final doc in messages.docs) {
      await doc.reference.delete();
    }

    await _chatRef.doc(orderId).delete();
  }
}
