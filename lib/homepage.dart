import 'package:flutter/material.dart';
import 'booking.dart';
import 'common/widgets/main_bottom_nav.dart';
import 'common/widgets/app_bar.dart';
import 'common/app_colors.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.page,

      // ================= APP BAR =================
      appBar: const PrebetAppBar(
        title: '',
        showLocation: true,
        location: 'UPSI - Kampus Sultan Azlan Shah',
        avatarText: 'D',
      ),

      // ================= BODY =================
      body: SingleChildScrollView(
        child: Column(
          children: [
            // MAP PLACEHOLDER
            Container(
              height: 260,
              width: double.infinity,
              color: AppColors.primaryLight,
              child: const Center(
                child: Text(
                  "MAP VIEW",
                  style: TextStyle(color: Colors.black54),
                ),
              ),
            ),

            // PICKUP & DESTINATION
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: AppColors.iconPrimary, // ✅ FIX
                  width: 1.5,
                ),
              ),
              child: Column(
                children: const [
                  Row(
                    children: [
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
                  SizedBox(height: 12),
                  Divider(),
                  SizedBox(height: 12),
                  Row(
                    children: [
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

            // QUICK ACTION
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
                      color: AppColors.textPrimary,
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
                      height: 56,
                      decoration: BoxDecoration(
                        color: AppColors.buttonPrimary,
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
      bottomNavigationBar: const MainBottomNav(
        currentIndex: 0,
      ),
    );
  }
}
