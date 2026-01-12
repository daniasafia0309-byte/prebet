import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:prebet/common/widgets/header.dart';

class RatingPage extends StatefulWidget {
  final String orderId;

  const RatingPage({
    super.key,
    required this.orderId,
  });

  @override
  State<RatingPage> createState() => _RatingPageState();
}

class _RatingPageState extends State<RatingPage> {
  int selectedRating = 0;
  bool isSubmitting = false;
  bool isLoading = true;

  final TextEditingController commentController = TextEditingController();

  late String driverId;
  late String driverName;
  late String vehicleInfo;
  int driverAvatarColor = 0xFFFF9800;
  bool isVerifiedDriver = true; 

  @override
  void initState() {
    super.initState();
    _loadBooking();
  }

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  Future<void> _loadBooking() async {
    try {
      final snap = await FirebaseFirestore.instance
          .collection('bookings')
          .doc(widget.orderId)
          .get();

      if (!snap.exists) throw Exception('Booking not found');

      final data = snap.data()!;

      // 🔒 Prevent double rating
      if (data['rated'] == true) {
        if (!mounted) return;
        Navigator.pop(context);
        return;
      }

      driverId = data['driverId'] ?? '';
      driverName = data['driverName'] ?? 'Driver';
      vehicleInfo = data['vehicleInfo'] ?? '';
      driverAvatarColor = data['driverAvatarColor'] ?? driverAvatarColor;

      setState(() => isLoading = false);
    } catch (_) {
      if (mounted) Navigator.pop(context);
    }
  }

  Future<void> _submitRating() async {
    if (isSubmitting || selectedRating == 0) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    setState(() => isSubmitting = true);

    try {
      final batch = FirebaseFirestore.instance.batch();

      final ratingRef =
          FirebaseFirestore.instance.collection('ratings').doc();

      final bookingRef =
          FirebaseFirestore.instance.collection('bookings').doc(widget.orderId);

      batch.set(ratingRef, {
        'orderId': widget.orderId,
        'userId': user.uid,
        'driverId': driverId,
        'rating': selectedRating,
        'comment': commentController.text.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      batch.update(bookingRef, {
        'rated': true,
        'status': 'completed', 
        'completedAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      await batch.commit();

      if (!mounted) return;
      Navigator.popUntil(context, (route) => route.isFirst);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to submit rating')),
      );
    } finally {
      if (mounted) setState(() => isSubmitting = false);
    }
  }

  void _skipRating() {
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const PrebetHeader(
        title: 'Rate Trip',
        showBack: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 140),
          child: Column(
            children: [
              const SizedBox(height: 12),

              CircleAvatar(
                radius: 40,
                backgroundColor: Color(driverAvatarColor),
                child: Text(
                  driverName[0].toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              Column(
                children: [
                  Text(
                    driverName,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (isVerifiedDriver)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.verified,
                            color: Colors.green, size: 20),
                        SizedBox(width: 6),
                        Text(
                          'Verified Driver',
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                ],
              ),

              const SizedBox(height: 10),

              Text(
                vehicleInfo,
                style: const TextStyle(fontSize: 15, color: Colors.grey),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 20),

              const Text(
                'Rate Your Trip',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 6),

              const Text(
                'How was your experience?',
                style: TextStyle(fontSize: 15, color: Colors.grey),
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  final star = index + 1;
                  return IconButton(
                    icon: Icon(
                      Icons.star,
                      size: 42,
                      color: star <= selectedRating
                          ? Colors.amber
                          : Colors.grey.shade400,
                    ),
                    onPressed: () =>
                        setState(() => selectedRating = star),
                  );
                }),
              ),

              const SizedBox(height: 26),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Share your experience (optional)',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              const SizedBox(height: 14),

              TextField(
                controller: commentController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Tell us about your ride...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: Color(0xFF0D7C7B)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: isSubmitting || selectedRating == 0
                      ? null
                      : _submitRating,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D7C7B),
                    disabledBackgroundColor: Colors.grey.shade400,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: isSubmitting
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Submit Rating',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: _skipRating,
                child: const Text(
                  'Skip for now',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
