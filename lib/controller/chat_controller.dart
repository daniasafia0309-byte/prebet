import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:prebet/data/chat_model.dart';

class ChatController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get uid {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not logged in');
    }
    return user.uid;
  }

  // ================= CREATE CHAT =================

  Future<void> createChatIfNotExists({
    required String orderId,
    required String driverId,
    String? driverName,
    int? driverAvatarColor,
  }) async {
    final chatRef = _firestore.collection('chats').doc(orderId);
    final chatSnap = await chatRef.get();

    if (!chatSnap.exists) {
      await chatRef.set({
        'orderId': orderId,
        'userId': uid,
        'driverId': driverId,
        'driverName': driverName ?? 'Driver',
        'driverAvatarColor': driverAvatarColor ?? 0xFF0D7C7B,
        'participants': [uid, driverId],
        'lastMessage': '',
        'lastSenderId': '',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }
  }

  // ================= SEND MESSAGE (FIX UTAMA) =================

  Future<void> sendMessage({
    required String orderId,
    required String receiverId,
    required String message,
  }) async {
    final chatRef = _firestore.collection('chats').doc(orderId);
    final messagesRef = chatRef.collection('messages');

    /// 🔧 FIX 1: Pastikan chat wujud
    final chatSnap = await chatRef.get();
    if (!chatSnap.exists) {
      await chatRef.set({
        'orderId': orderId,
        'userId': uid,
        'driverId': receiverId,
        'driverName': 'Driver',
        'driverAvatarColor': 0xFF0D7C7B,
        'participants': [uid, receiverId],
        'lastMessage': '',
        'lastSenderId': '',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }

    final chatMessage = ChatModel(
      id: '',
      message: message,
      senderId: uid,
      receiverId: receiverId,
      timestamp: DateTime.now(),
      isRead: false,
    );

    /// ADD MESSAGE
    await messagesRef.add({
      'text': chatMessage.message,
      'senderId': chatMessage.senderId,
      'receiverId': chatMessage.receiverId,
      'createdAt': FieldValue.serverTimestamp(),
      'isRead': false,
    });

    /// 🔧 FIX 2: UPDATE CHAT INFO (INI YANG BUAT CHAT NAIK)
    await chatRef.update({
      'lastMessage': message,
      'lastSenderId': uid,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // ================= STREAM MESSAGES =================

  Stream<List<ChatModel>> streamMessages(String orderId) {
    return _firestore
        .collection('chats')
        .doc(orderId)
        .collection('messages')
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => ChatModel.fromDocument(doc)).toList(),
        );
  }

  // ================= MARK READ =================

  Future<void> markMessageAsRead({
    required String orderId,
    required String messageId,
  }) async {
    await _firestore
        .collection('chats')
        .doc(orderId)
        .collection('messages')
        .doc(messageId)
        .update({'isRead': true});
  }

  // ================= STREAM USER CHATS =================

  Stream<QuerySnapshot<Map<String, dynamic>>> streamUserChats() {
    return _firestore
        .collection('chats')
        .where('participants', arrayContains: uid)
        .orderBy('updatedAt', descending: true)
        .snapshots();
  }
}
