import 'dart:async';
import 'package:flutter/material.dart';
import 'rating.dart'; // 🔗 IMPORT RATING PAGE

class LiveTrackingPage extends StatefulWidget {
  const LiveTrackingPage({super.key});

  @override
  State<LiveTrackingPage> createState() => _LiveTrackingPageState();
}

class _LiveTrackingPageState extends State<LiveTrackingPage> {
  static const int totalSeconds = 200; // 3 min 20 sec
  int remainingSeconds = totalSeconds;
  late Timer timer;

  bool hasNavigated = false;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void _startCountdown() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds > 0) {
        setState(() {
          remainingSeconds--;
        });
      } else {
        timer.cancel();

        if (!hasNavigated) {
          hasNavigated = true;

          Future.delayed(const Duration(milliseconds: 500), () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const RatingPage(),
              ),
            );
          });
        }
      }
    });
  }

  String get formattedTime {
    final minutes = remainingSeconds ~/ 60;
    final seconds = remainingSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  double get progress {
    return (totalSeconds - remainingSeconds) / totalSeconds;
  }

  String get statusText {
    if (progress < 0.25) return 'On the way';
    if (progress < 0.5) return 'Arrived';
    if (progress < 0.75) return 'In transit';
    return 'Complete';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // ================= APP BAR =================
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Live Tracking',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),

      // ================= BODY =================
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ================= MAP MOCK =================
            Stack(
              children: [
                Container(
                  height: 260,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.teal.shade100,
                        Colors.teal.shade50,
                      ],
                    ),
                  ),
                ),

                Positioned(
                  left: 40,
                  top: 120,
                  child: Container(
                    width: 280,
                    height: 4,
                    color: Colors.white,
                  ),
                ),

                Positioned(
                  left: 30,
                  top: 80,
                  child: Icon(
                    Icons.location_on,
                    size: 50,
                    color: Colors.teal.shade600,
                  ),
                ),

                Positioned(
                  right: 40,
                  top: 110,
                  child: const Icon(
                    Icons.directions_car,
                    size: 40,
                    color: Colors.orange,
                  ),
                ),

                // ETA Bubble
                Positioned(
                  right: 20,
                  top: 30,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      remainingSeconds == 0
                          ? 'Trip Completed'
                          : 'Arriving in\n$formattedTime',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // ================= DRIVER INFO =================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 22,
                    backgroundColor: Colors.orange,
                    child: Text(
                      'A',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ahmad Zaki',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Perodua Myvi Black\nABC 1234',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Price',
                        style:
                            TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      Text(
                        'RM 5.00',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ================= STATUS CARD =================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.teal.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.directions_car,
                            color: Colors.teal),
                        const SizedBox(width: 6),
                        Text(
                          'Driver status: $statusText',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.teal.shade100,
                      color: Colors.teal,
                      minHeight: 6,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: const [
                        Expanded(
                          child: Text('On the way',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 11)),
                        ),
                        Expanded(
                          child: Text('Arrived',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 11)),
                        ),
                        Expanded(
                          child: Text('In transit',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 11)),
                        ),
                        Expanded(
                          child: Text('Complete',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 11)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ================= ACTION BUTTONS =================
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  _actionButton(
                    icon: Icons.chat_bubble_outline,
                    label: 'Chat',
                    color: Colors.teal,
                  ),
                  _actionButton(
                    icon: Icons.call,
                    label: 'Call',
                    color: Colors.green,
                  ),
                  _actionButton(
                    icon: Icons.warning,
                    label: 'SOS',
                    color: Colors.red,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionButton({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white),
              const SizedBox(height: 4),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
