import 'package:flutter/material.dart';
import 'driver_detail.dart';

class BookingPage extends StatelessWidget {
  const BookingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

      // ================= APP BAR =================
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Book a ride",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),

      // ================= BODY =================
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Available Drivers",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 12),

            Expanded(
              child: ListView(
                children: const [
                  DriverCard(
                    name: "Ahmad Zaki",
                    rating: 4.9,
                    car: "Perodua Myvi · ABC1234",
                    carColor: "Black",
                    price: "RM 5.00",
                    avatarColor: Colors.orange,
                    verified: true,
                  ),
                  DriverCard(
                    name: "Fatimah Ali",
                    rating: 4.8,
                    car: "Proton Saga · ALA1010",
                    carColor: "White",
                    price: "RM 5.50",
                    avatarColor: Colors.pink,
                    verified: true,
                  ),
                  DriverCard(
                    name: "Sofia Aina",
                    rating: 4.8,
                    car: "Proton Iris · VAD6789",
                    carColor: "Purple",
                    price: "RM 6.00",
                    avatarColor: Colors.purple,
                    verified: true,
                  ),
                  DriverCard(
                    name: "Kamal",
                    rating: 4.8,
                    car: "Perodua Bezza · CAD4321",
                    carColor: "Brown",
                    price: "RM 6.00",
                    avatarColor: Colors.brown,
                    verified: true,
                  ),

                  // ⭐ DRIVER DENGAN AVATAR #00C3D0
                  DriverCard(
                    name: "Ammar Ali",
                    rating: 4.8,
                    car: "Perodua Myvi · ABA4020",
                    carColor: "Yellow",
                    price: "RM 6.50",
                    avatarColor: Color(0xFF00C3D0), // ✅ DIMINTA
                    verified: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // ================= BOTTOM NAV =================
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: const Color(0xFF0D7C7B),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_car),
            label: "My Rides",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: "Chat",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}

// ================= DRIVER CARD =================
class DriverCard extends StatelessWidget {
  final String name;
  final double rating;
  final String car;
  final String carColor;
  final String price;
  final Color avatarColor;
  final bool verified;

  const DriverCard({
    super.key,
    required this.name,
    required this.rating,
    required this.car,
    required this.carColor,
    required this.price,
    required this.avatarColor,
    this.verified = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFF0D7C7B),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          CircleAvatar(
            radius: 22,
            backgroundColor: avatarColor,
            child: Text(
              name[0],
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Driver Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 6),
                    if (verified)
                      const Icon(
                        Icons.verified,
                        size: 16,
                        color: Colors.green,
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star,
                        size: 14, color: Colors.orange),
                    const SizedBox(width: 4),
                    Text(
                      rating.toString(),
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  "$car\n$carColor",
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),

          // Price & Select
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                price,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 6),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DriverDetailPage(),
                    ),
                  );
                },
                child: const Text(
                  "Select",
                  style: TextStyle(
                    color: Color(0xFF0D7C7B),
                    fontWeight: FontWeight.bold,
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
