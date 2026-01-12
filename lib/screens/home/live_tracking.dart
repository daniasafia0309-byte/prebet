import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prebet/common/widgets/header.dart';
import 'package:prebet/screens/home/rating.dart';
import 'package:prebet/screens/messages/chat_detail.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LiveTrackingPage extends StatefulWidget {
  final String orderId;

  const LiveTrackingPage({
    super.key,
    required this.orderId,
  });

  @override
  State<LiveTrackingPage> createState() => _LiveTrackingPageState();
}

class _LiveTrackingPageState extends State<LiveTrackingPage> {
  static const Color primaryGreen = Color(0xFF0D7C7B);

  String driverName = '';
  String vehicleInfo = '';
  String paymentStatus = '';
  String driverId = '';
  int driverAvatarColor = 0xFFFF9800;
  double price = 0.0;

  bool isLoading = true;
  bool isChatOpened = false;

  int currentStep = 0;
  double progress = 0.0;
  Timer? _timer;

  String? _selectedCancelReason;

  final List<String> _cancelReasons = [
    'Driver taking too long',
    'Wrong pickup location',
    'Change of plan',
    'Booked by mistake',
    'Other reason',
  ];

  final List<String> _statusText = [
    'Driver is on the way',
    'Driver has arrived',
    'Trip completed',
  ];

  final List<Color> _statusColor = [
    Colors.blue,
    Colors.orange,
    Colors.green,
  ];

  final List<Color> _statusBgColor = [
    Colors.blueAccent.withOpacity(0.08),
    Colors.orangeAccent.withOpacity(0.08),
    Colors.greenAccent.withOpacity(0.08),
  ];

  @override
  void initState() {
    super.initState();
    _loadBooking();
  }

  Future<void> _loadBooking() async {
    try {
      final snap = await FirebaseFirestore.instance
          .collection('bookings')
          .doc(widget.orderId)
          .get();

      final data = snap.data()!;
      driverName = data['driverName'] ?? '';
      vehicleInfo = data['vehicleInfo'] ?? '';
      paymentStatus = data['paymentStatus'] ?? 'paid';
      driverId = data['driverId'] ?? '';
      driverAvatarColor = data['driverAvatarColor'] ?? 0xFFFF9800;
      price = (data['price'] as num?)?.toDouble() ?? 0.0;

      setState(() => isLoading = false);

      Future.delayed(const Duration(seconds: 10), () {
        if (mounted && !isChatOpened) {
          _startJourneySimulation();
        }
      });
    } catch (_) {
      Navigator.pop(context);
    }
  }

  void _startJourneySimulation() {
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 15), (timer) async {
      if (isChatOpened) {
        timer.cancel();
        return;
      }

      if (currentStep < 2) {
        setState(() {
          currentStep++;
          progress = currentStep == 1 ? 0.5 : 1.0;
        });
      } else {
        timer.cancel();

        await FirebaseFirestore.instance
            .collection('bookings')
            .doc(widget.orderId)
            .update({
          'status': 'completed',
          'completedAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });

        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => RatingPage(orderId: widget.orderId),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // ================= UI =================

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: PrebetHeader(
        title: 'Live Tracking',
        showBack: false,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            itemBuilder: (_) => const [
              PopupMenuItem(
                value: 'cancel',
                child: Text('Cancel Order'),
              ),
            ],
            onSelected: (_) => _showCancelDialog(),
          ),
        ],
      ),
      body: Column(
        children: [
          _heroJourneyProgress(),
          _driverCard(),
          const Spacer(),
          _actionButtons(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // ================= PROGRESS WITH USER ICON =================

  Widget _heroJourneyProgress() => Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: _statusBgColor[currentStep],
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          children: [
            Text(
              _statusText[currentStep],
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _statusColor[currentStep],
              ),
            ),
            const SizedBox(height: 20),

            /// ICON STATUS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _iconBubble(Icons.directions_car, Colors.blue),
                _iconBubble(Icons.location_on, Colors.orange),
                _iconBubble(Icons.check_circle, Colors.green),
              ],
            ),

            const SizedBox(height: 24),

            /// PROGRESS BAR + USER ICON
            LayoutBuilder(
              builder: (context, constraints) {
                final barWidth = constraints.maxWidth;
                final userPosition = barWidth * progress;

                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    LinearProgressIndicator(
                      value: progress,
                      minHeight: 10,
                      color: _statusColor[currentStep],
                      backgroundColor: Colors.grey.shade300,
                    ),

                    /// USER ICON
                    Positioned(
                      left: userPosition - 14,
                      top: -18,
                      child: CircleAvatar(
                        radius: 14,
                        backgroundColor: _statusColor[currentStep],
                        child: const Icon(
                          Icons.person,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      );

  Widget _iconBubble(IconData icon, Color color) =>
      CircleAvatar(radius: 22, backgroundColor: color, child: Icon(icon, color: Colors.white));

  // ================= DRIVER CARD =================

  Widget _driverCard() => Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: primaryGreen.withOpacity(0.08),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: Color(driverAvatarColor),
              child: Text(
                driverName.isNotEmpty ? driverName[0] : 'D',
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(driverName,
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  Text(vehicleInfo,
                      style: const TextStyle(fontSize: 13, color: Colors.grey)),
                  const SizedBox(height: 4),
                  Text(
                    'Payment: ${paymentStatus.toUpperCase()}',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: paymentStatus == 'paid'
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),
                ],
              ),
            ),
            Text('RM ${price.toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      );

  // ================= ACTIONS =================

  Widget _actionButtons() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            _actionButton(Icons.chat, 'Chat', primaryGreen,
                () => _openChat(context)),
            const SizedBox(width: 12),
            _actionButton(Icons.warning_amber_rounded, 'SOS', Colors.red, _callSOS),
          ],
        ),
      );

  Widget _actionButton(
    IconData icon,
    String label,
    Color color,
    VoidCallback onTap,
  ) =>
      Expanded(
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            height: 64,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.white),
                const SizedBox(height: 6),
                Text(
                  label,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
      );

  // ================= CANCEL =================

  void _showCancelDialog() {
    _selectedCancelReason = null;

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setStateDialog) => AlertDialog(
          title: const Text('Cancel Order'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: _cancelReasons.map((reason) {
              return RadioListTile<String>(
                title: Text(reason),
                value: reason,
                groupValue: _selectedCancelReason,
                onChanged: (value) {
                  setStateDialog(() {
                    _selectedCancelReason = value;
                  });
                },
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed:
                  _selectedCancelReason == null ? null : _confirmCancelOrder,
              child: const Text('Confirm',
                  style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmCancelOrder() async {
    await FirebaseFirestore.instance
        .collection('bookings')
        .doc(widget.orderId)
        .update({
      'status': 'cancelled',
      'cancelReason': _selectedCancelReason,
      'cancelledBy': 'user',
      'cancelledAt': FieldValue.serverTimestamp(),
    });

    _timer?.cancel();

    if (!mounted) return;
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  // ================= CHAT & SOS =================

  Future<void> _openChat(BuildContext context) async {
    isChatOpened = true;
    _timer?.cancel();

    final userId = FirebaseAuth.instance.currentUser!.uid;

    final chatRef =
        FirebaseFirestore.instance.collection('chats').doc(widget.orderId);

    if (!(await chatRef.get()).exists) {
      await chatRef.set({
        'orderId': widget.orderId,
        'userId': userId,
        'driverId': driverId,
        'driverName': driverName,
        'driverAvatarColor': driverAvatarColor,
        'vehicleInfo': vehicleInfo,
        'participants': [userId, driverId],
        'lastMessage': 'Start a conversation',    
        'lastSenderId': '',
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChatDetailPage(
          orderId: widget.orderId,
          driverId: driverId,
          driverName: driverName.isEmpty ? 'Driver' : driverName,
        ),
      ),
    );

    isChatOpened = false;
    _startJourneySimulation();
  }

  void _callSOS() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('SOS Alert'),
        content: const Text(
          'This is a demo SOS feature.\n\n'
          'In a real implementation, this will contact emergency services.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}
