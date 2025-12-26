import 'package:flutter/material.dart';
import 'common/widgets/main_bottom_nav.dart';
import 'common/widgets/app_bar.dart';
import 'common/app_colors.dart';

class MyRidesPage extends StatefulWidget {
  const MyRidesPage({super.key});

  @override
  State<MyRidesPage> createState() => _MyRidesPageState();
}

class _MyRidesPageState extends State<MyRidesPage> {
  int selectedTab = 0; // 0 = All, 1 = Completed, 2 = Cancelled

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.page,

      // ================= APP BAR (REUSABLE) =================
      appBar: const PrebetAppBar(
        title: 'My Rides',
      ),

      // ================= BODY =================
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ================= FILTER TABS =================
            Row(
              children: [
                _tabButton('All', 0),
                _tabButton('Completed', 1),
                _tabButton('Cancelled', 2),
              ],
            ),

            const SizedBox(height: 20),

            // ================= RECENT ACTIVITY =================
            Row(
              children: const [
                Icon(Icons.calendar_today, size: 16),
                SizedBox(width: 8),
                Text(
                  'Recent Activity',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // ================= RIDE LIST =================
            Expanded(
              child: ListView(
                children: const [
                  RideCard(
                    name: 'Ahmad Zaki',
                    price: 'RM 5.00',
                    pickup: 'KHAR Block 4, KSAS',
                    destination: 'Complex Academic',
                    time: 'Today, 2:30 PM',
                    rating: 5,
                  ),
                  RideCard(
                    name: 'Fatimah Ali',
                    price: 'RM 7.00',
                    pickup: 'KHAR Block 4, KSAS',
                    destination: 'East Gate, KSAJS',
                    time: 'Yesterday, 10:15 AM',
                    rating: 5,
                  ),
                  RideCard(
                    name: 'Sofia Alia',
                    price: 'RM 5.00',
                    pickup: 'College Zaaba',
                    destination: 'Library KSAS',
                    time: 'Yesterday, 8:40 AM',
                    rating: 4,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // ================= BOTTOM NAV =================
      bottomNavigationBar: const MainBottomNav(
        currentIndex: 1, // My Rides
      ),
    );
  }

  // ================= TAB BUTTON =================
  Widget _tabButton(String title, int index) {
    final bool isActive = selectedTab == index;

    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedTab = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.primary
                : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            title,
            style: TextStyle(
              color: isActive
                  ? Colors.white
                  : AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

// ================= RIDE CARD =================
class RideCard extends StatelessWidget {
  final String name;
  final String price;
  final String pickup;
  final String destination;
  final String time;
  final int rating;

  const RideCard({
    super.key,
    required this.name,
    required this.price,
    required this.pickup,
    required this.destination,
    required this.time,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // STATUS & PRICE
          Row(
            children: [
              const Icon(Icons.circle, size: 8, color: AppColors.success),
              const SizedBox(width: 6),
              const Text(
                'Completed',
                style: TextStyle(
                  color: AppColors.success,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Text(
                price,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // NAME
          Text(
            name,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),

          const SizedBox(height: 10),

          // PICKUP
          Row(
            children: [
              const Icon(Icons.circle, size: 8, color: AppColors.success),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  pickup,
                  style: const TextStyle(fontSize: 13),
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          // DESTINATION
          Row(
            children: [
              const Icon(Icons.circle, size: 8, color: AppColors.error),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  destination,
                  style: const TextStyle(fontSize: 13),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // TIME & RATING
          Row(
            children: [
              Text(
                time,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textHint,
                ),
              ),
              const Spacer(),
              Row(
                children: List.generate(
                  5,
                  (index) => Icon(
                    Icons.star,
                    size: 14,
                    color: index < rating
                        ? Colors.amber
                        : Colors.grey.shade400,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
