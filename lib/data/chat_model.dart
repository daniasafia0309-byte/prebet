import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  final String id;
  final String message;
  final String senderId;
  final String receiverId;
  final DateTime timestamp;
  final bool isRead;

  ChatModel({
    required this.id,
    required this.message,
    required this.senderId,
    required this.receiverId,
    required this.timestamp,
    this.isRead = false,
  });

  // ================= TO FIRESTORE =================
  Map<String, dynamic> toMap() {
    return {
      'text': message, // ✅ IKUT DATABASE
      'senderId': senderId,
      'receiverId': receiverId,
      'createdAt': Timestamp.fromDate(timestamp), // ✅ IKUT DATABASE
      'isRead': isRead,
    };
  }

  // ================= FROM FIRESTORE =================
  factory ChatModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return ChatModel(
      id: doc.id,
      message: data['text'] ?? '', // ✅ BETUL
      senderId: data['senderId'] ?? '',
      receiverId: data['receiverId'] ?? '',
      timestamp:
          (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isRead: data['isRead'] ?? false,
    );
  }

  ChatModel copyWith({
    String? id,
    String? message,
    String? senderId,
    String? receiverId,
    DateTime? timestamp,
    bool? isRead,
  }) {
    return ChatModel(
      id: id ?? this.id,
      message: message ?? this.message,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
    );
  }
}
