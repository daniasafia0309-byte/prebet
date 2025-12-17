import 'package:flutter/material.dart';
import 'booking.dart';
import 'common/widgets/main_bottom_nav.dart';

// IMPORT PAGE NAVIGATION
import 'my_rides.dart';
import 'chat.dart';
import 'profile.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

      // ================= APP BAR =================
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        titleSpacing: 0,
        title: ListTile(
          leading: const Icon(
            Icons.location_on,
            color: Color(0xFF0D7C7B),
          ),
          title: const Text(
            "Location",
            style: TextStyle(fontSize: 12),
          ),
          subtitle: const Text(
            "UPSI - Kampus Sultan Azlan Shah",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: CircleAvatar(
              backgroundColor: const Color(0xFF0D7C7B),
              child: const Text(
                "D",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),

      // ================= BODY =================
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ================= MAP =================
            Container(
              height: 260,
              width: double.infinity,
              color: Colors.green.shade100,
              child: const Center(
                child: Text(
                  "MAP VIEW",
                  style: TextStyle(color: Colors.black54),
                ),
              ),
            ),

            // ================= PICKUP & DESTINATION =================
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: Colors.blue,
                  width: 1.5,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: const [
                      Icon(Icons.circle, size: 10, color: Colors.green),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "Pickup Location\nCurrent Location (GPS)",
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                      Icon(Icons.my_location, color: Colors.blue),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Divider(),
                  const SizedBox(height: 12),
                  Row(
                    children: const [
                      Icon(Icons.circle, size: 10, color: Colors.red),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "East Gate, KSASJ",
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                      Icon(Icons.location_on, color: Colors.teal),
                    ],
                  ),
                ],
              ),
            ),

            // ================= QUICK ACTION =================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Quick Actions",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 12),

                  InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const BookingPage(),
                        ),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      height: 56,
                      decoration: BoxDecoration(
                        color: const Color(0xFF0D7C7B),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.directions_car, color: Colors.white),
                          SizedBox(width: 10),
                          Text(
                            "Order Prebet",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 80),
                ],
              ),
            ),
          ],
        ),
      ),

      // ================= BOTTOM NAV =================
      bottomNavigationBar: MainBottomNav(
        currentIndex: 0, // Home
        onTap: (index) {
          if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => MyRidesPage()),
            );
          } else if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => ChatPage()),
            );
          } else if (index == 3) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => ProfilePage()),
            );
          }
        },
      ),
    );
  }
}
