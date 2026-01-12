import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class MyRidesPage extends StatefulWidget {
  const MyRidesPage({super.key});

  @override
  State<MyRidesPage> createState() => _MyRidesPageState();
}

class _MyRidesPageState extends State<MyRidesPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final User? _user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // ================= FIRESTORE STREAM =================
  Stream<QuerySnapshot<Map<String, dynamic>>> _ridesStream(String status) {
    if (_user == null) return const Stream.empty();

    return FirebaseFirestore.instance
        .collection('bookings')
        .where('userId', isEqualTo: _user.uid)
        .where('status', isEqualTo: status)
        .snapshots();
  }

  // ================= RATING STREAM =================
  Stream<int?> _ratingStream(String bookingId) {
    return FirebaseFirestore.instance
        .collection('ratings')
        .where('orderId', isEqualTo: bookingId)
        .limit(1)
        .snapshots()
        .map((snap) {
      if (snap.docs.isEmpty) return null;
      return (snap.docs.first['rating'] ?? 0) as int;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      return const Scaffold(
        body: Center(child: Text('Please login first')),
      );
    }

    final bool isCancelledTab = _tabController.index == 1;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          // ================= TAB BAR =================
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              indicatorColor:
                  isCancelledTab ? Colors.red : Colors.green,
              labelColor:
                  isCancelledTab ? Colors.red : Colors.green,
              unselectedLabelColor: Colors.grey,
              indicatorWeight: 3,
              tabs: const [
                Tab(text: 'Completed'),
                Tab(text: 'Cancelled'),
              ],
            ),
          ),

          // ================= CONTENT =================
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _ridesList('completed'),
                _ridesList('cancelled'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================= RIDES LIST =================
  Widget _ridesList(String status) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: _ridesStream(status),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return _emptyState(
            icon: status == 'completed'
                ? Icons.directions_car_outlined
                : Icons.cancel_outlined,
            title: status == 'completed'
                ? 'No completed rides yet'
                : 'No cancelled rides',
            subtitle: status == 'completed'
                ? 'Your completed trips will appear here once you start booking.'
                : 'Any cancelled trips will be shown here.',
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: snapshot.data!.docs.length,
          separatorBuilder: (_, __) => const SizedBox(height: 14),
          itemBuilder: (context, index) {
            final doc = snapshot.data!.docs[index];
            return _rideCard(
              bookingId: doc.id,
              data: doc.data(),
              status: status,
            );
          },
        );
      },
    );
  }

  // ================= RIDE CARD =================
  Widget _rideCard({
    required String bookingId,
    required Map<String, dynamic> data,
    required String status,
  }) {
    final Timestamp? ts =
        data['completedAt'] ?? data['updatedAt'] ?? data['createdAt'];

    final String date = ts != null
        ? DateFormat('dd MMM yyyy, hh:mm a').format(ts.toDate())
        : '-';

    final Color avatarColor =
        Color(data['driverAvatarColor'] ?? 0xFF0D7C7B);

    final double price =
        (data['price'] as num?)?.toDouble() ?? 0.0;

    // ⭐ CANCELLED REASON
    final String cancelReason =
        (data['cancelReason'] ?? 'No reason provided').toString();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ===== DRIVER HEADER =====
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: avatarColor,
                child: Text(
                  (data['driverName'] ?? 'D')[0],
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data['driverName'] ?? 'Driver',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      data['vehicleInfo'] ?? '',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                'RM ${price.toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),

          const SizedBox(height: 14),

          _locationRow(
            icon: Icons.my_location,
            color: Colors.green,
            label: 'From',
            value: data['pickup'] ?? '-',
          ),
          const SizedBox(height: 8),
          _locationRow(
            icon: Icons.location_on,
            color: Colors.redAccent,
            label: 'To',
            value: data['destination'] ?? '-',
          ),

          // ⭐ CANCELLED REASON DISPLAY
          if (status == 'cancelled') ...[
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.error_outline,
                    size: 18, color: Colors.red),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '$cancelReason',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.red,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ],

          if (status == 'completed') ...[
            const SizedBox(height: 12),
            StreamBuilder<int?>(
              stream: _ratingStream(bookingId),
              builder: (context, snap) {
                if (!snap.hasData || snap.data == null) {
                  return const Text(
                    'Not rated',
                    style:
                        TextStyle(fontSize: 12, color: Colors.grey),
                  );
                }

                return Row(
                  children: List.generate(5, (i) {
                    return Icon(
                      Icons.star,
                      size: 16,
                      color: i < snap.data!
                          ? Colors.amber
                          : Colors.grey.shade300,
                    );
                  }),
                );
              },
            ),
          ],

          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                date,
                style:
                    const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              Text(
                status.toUpperCase(),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: status == 'completed'
                      ? Colors.green
                      : Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ================= LOCATION ROW =================
  Widget _locationRow({
    required IconData icon,
    required Color color,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 8),
        SizedBox(
          width: 48,
          child: Text(
            '$label:',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 13),
          ),
        ),
      ],
    );
  }

  // ================= EMPTY STATE =================
  Widget _emptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 90, color: Colors.grey.shade400),
            const SizedBox(height: 20),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
