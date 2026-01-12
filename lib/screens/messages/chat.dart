import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:prebet/common/app_colors.dart';
import 'chat_detail.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  static const String supportId = 'SUPPORT';

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Please login')),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('chats')
            .where('participants', arrayContains: user.uid)
            // ❌ BUANG orderBy (query ketat)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'No conversations yet',
                style: TextStyle(color: Colors.grey),
              ),
            );
          }

          final docs = snapshot.data!.docs.toList();

          // ✅ SORT DALAM FLUTTER (SELAMAT)
          docs.sort((a, b) {
            final aTime = a.data()['updatedAt'] ?? a.data()['createdAt'];
            final bTime = b.data()['updatedAt'] ?? b.data()['createdAt'];

            if (aTime == null || bTime == null) return 0;

            return (bTime as Timestamp)
                .compareTo(aTime as Timestamp);
          });

          final List<_ChatTileData> chats = [];

          /// ================= SUPPORT CHAT =================
          chats.add(
            _ChatTileData(
              name: 'Prebet Support',
              avatarColor: AppColors.primaryColor,
              message: 'How can we help you?',
              time: '',
              orderId: supportId,
              driverId: supportId,
            ),
          );

          /// ================= USER CHATS =================
          for (final doc in docs) {
            final data = doc.data();

            final String lastMessage =
                (data['lastMessage'] ?? 'Start a conversation').toString();

            String time = '';
            final ts = data['updatedAt'] ?? data['createdAt'];
            if (ts is Timestamp) {
              time = DateFormat('hh:mm a').format(ts.toDate());
            }

            chats.add(
              _ChatTileData(
                name: (data['driverName'] ?? 'Driver').toString(),
                avatarColor:
                    Color(data['driverAvatarColor'] ?? 0xFF0D7C7B),
                message: lastMessage,
                time: time,
                orderId: doc.id,
                driverId: (data['driverId'] ?? '').toString(),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 6),
            itemCount: chats.length,
            separatorBuilder: (_, __) => const Divider(
              height: 1,
              indent: 72,
            ),
            itemBuilder: (_, index) {
              final chat = chats[index];

              return ChatTile(
                name: chat.name,
                avatarColor: chat.avatarColor,
                message: chat.message,
                time: chat.time,
                orderId: chat.orderId,
                driverId: chat.driverId,
              );
            },
          );
        },
      ),
    );
  }
}

/// ================= CHAT TILE =================

class ChatTile extends StatelessWidget {
  final String name;
  final Color avatarColor;
  final String message;
  final String time;
  final String orderId;
  final String driverId;

  const ChatTile({
    super.key,
    required this.name,
    required this.avatarColor,
    required this.message,
    required this.time,
    required this.orderId,
    required this.driverId,
  });

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    return InkWell(
      onTap: () async {
        final result = await Navigator.push<Map<String, dynamic>?>(
          context,
          MaterialPageRoute(
            builder: (_) => ChatDetailPage(
              orderId: orderId,
              driverName: name,
              driverId: driverId,
            ),
          ),
        );

        if (result != null && result['message'] != null) {
          await FirebaseFirestore.instance
              .collection('chats')
              .doc(orderId)
              .update({
            'lastMessage': result['message'],
            'lastSenderId': userId,
            'updatedAt': FieldValue.serverTimestamp(),
          });
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: avatarColor,
              child: Text(
                name.isNotEmpty ? name[0].toUpperCase() : '?',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            if (time.isNotEmpty)
              Text(
                time,
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.grey,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// ================= HELPER MODEL =================

class _ChatTileData {
  final String name;
  final Color avatarColor;
  final String message;
  final String time;
  final String orderId;
  final String driverId;

  _ChatTileData({
    required this.name,
    required this.avatarColor,
    required this.message,
    required this.time,
    required this.orderId,
    required this.driverId,
  });
}
