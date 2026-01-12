import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:prebet/common/app_colors.dart';

class ChatDetailPage extends StatefulWidget {
  final String orderId;
  final String driverName;
  final String driverId;

  const ChatDetailPage({
    super.key,
    required this.orderId,
    required this.driverName,
    required this.driverId,
  });

  @override
  State<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  final TextEditingController _messageCtrl = TextEditingController();
  final ScrollController _scrollCtrl = ScrollController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get uid => _auth.currentUser!.uid;

  /// ✅ SIMPAN MESEJ TERAKHIR
  String _lastMessage = '';

  @override
  void initState() {
    super.initState();
    _createChatIfNotExist();
  }

  @override
  void dispose() {
    _messageCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  Future<void> _createChatIfNotExist() async {
    final ref = _firestore.collection('chats').doc(widget.orderId);
    final snap = await ref.get();

    if (!snap.exists) {
      await ref.set({
  'orderId': widget.orderId,
  'userId': uid,
  'driverId': widget.driverId,
  'driverName': widget.driverName,
  'participants': [uid, widget.driverId],
  'lastMessage': 'Start a conversation',
  'lastSenderId': '',
  'updatedAt': FieldValue.serverTimestamp(),
});

    }
  }

  Future<void> _send() async {
    final text = _messageCtrl.text.trim();
    if (text.isEmpty) return;

    _messageCtrl.clear();
    _lastMessage = text; // ✅ SIMPAN

    final chatRef = _firestore.collection('chats').doc(widget.orderId);

    await chatRef.collection('messages').add({
      'text': text,
      'senderId': uid,
      'createdAt': FieldValue.serverTimestamp(),
    });

    await chatRef.update({
      'lastMessage': text,
      'lastSenderId': uid,
      'updatedAt': FieldValue.serverTimestamp(),
    });

    await Future.delayed(const Duration(milliseconds: 200));
    if (_scrollCtrl.hasClients) {
      _scrollCtrl.jumpTo(_scrollCtrl.position.maxScrollExtent);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      /// ✅ HANTAR BALIK MESEJ TERAKHIR
      onWillPop: () async {
        Navigator.pop(context, {
          'message': _lastMessage,
        });
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primaryColor,
          elevation: 0,
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.white),
          title: Text(
            widget.driverName,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: _firestore
                    .collection('chats')
                    .doc(widget.orderId)
                    .collection('messages')
                    .orderBy('createdAt')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                        child: CircularProgressIndicator());
                  }

                  final docs = snapshot.data?.docs ?? [];

                  if (docs.isEmpty) {
                    return const Center(
                      child: Text(
                        'No messages yet',
                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  }

                  return ListView.builder(
                    controller: _scrollCtrl,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 12),
                    itemCount: docs.length,
                    itemBuilder: (_, i) {
                      final d = docs[i].data();
                      final isMe = d['senderId'] == uid;

                      return Align(
                        alignment: isMe
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin:
                              const EdgeInsets.symmetric(vertical: 4),
                          padding: const EdgeInsets.all(12),
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context)
                                    .size
                                    .width *
                                0.75,
                          ),
                          decoration: BoxDecoration(
                            color: isMe
                                ? AppColors.primaryColor
                                : Colors.grey.shade300,
                            borderRadius:
                                BorderRadius.circular(16),
                          ),
                          child: Text(
                            d['text'] ?? '',
                            style: TextStyle(
                              color:
                                  isMe ? Colors.white : Colors.black,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageCtrl,
                        textInputAction: TextInputAction.send,
                        onSubmitted: (_) => _send(),
                        decoration: InputDecoration(
                          hintText: 'Type message',
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(24),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding:
                              const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    IconButton(
                      icon: const Icon(
                        Icons.send,
                        color: AppColors.primaryColor,
                      ),
                      onPressed: _send,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
