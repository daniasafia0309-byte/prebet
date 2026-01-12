import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:prebet/repositories/booking_repositories.dart';

class BookingController extends ChangeNotifier {
  final OrderRepository _repo = OrderRepository();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool isLoading = false;

  Future<String> createBooking({
    required String pickup,
    required String destination,
    required String bookingDate,
    required String bookingTime,
    required int passenger,
    required double price, 
    required String driverId,
    required String driverName,
    required int driverAvatarColor,
    int eta = 4,
  }) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not logged in');
    }

    isLoading = true;
    notifyListeners();

    try {
      final now = DateTime.now();

      final Map<String, dynamic> data = {
      
        'userId': user.uid,

        'pickup': pickup,
        'destination': destination,

        'bookingDate': bookingDate,
        'bookingTime': bookingTime,
        'passenger': passenger,
        'eta': eta,

        'driverId': driverId,
        'driverName': driverName,
        'driverAvatarColor': driverAvatarColor,

        'price': price,
        'pricingType': 'location_based',
        'fareBreakdown': {
          'baseFare': price,
          'passenger': passenger,
          'currency': 'MYR',
        },

        'paymentStatus': 'unpaid',
        'status': 'pending',
        'rated': false,
        'pointsEarned': 10,

        'createdAt': Timestamp.fromDate(now),
        'updatedAt': Timestamp.fromDate(now),
        'serverCreatedAt': FieldValue.serverTimestamp(),
        'serverUpdatedAt': FieldValue.serverTimestamp(),

        'completedAt': null,
        'cancelReason': null,
      };

      final orderId = await _repo.createOrder(data);
      return orderId;
    } catch (e, s) {
      debugPrint('❌ createBooking error: $e');
      debugPrintStack(stackTrace: s);
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamMyBookings() {
    final user = _auth.currentUser;
    if (user == null) {
      return const Stream.empty();
    }

    return FirebaseFirestore.instance
        .collection('bookings')
        .where('userId', isEqualTo: user.uid)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Future<void> markAsPaid(String orderId) async {
    try {
      await _repo.updateOrder(orderId, {
        'paymentStatus': 'paid',
        'status': 'ongoing',
        'updatedAt': Timestamp.fromDate(DateTime.now()),
        'serverUpdatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e, s) {
      debugPrint('❌ markAsPaid error: $e');
      debugPrintStack(stackTrace: s);
    }
  }

  Future<void> completeBooking(String orderId) async {
    try {
      final now = DateTime.now();

      await _repo.updateOrder(orderId, {
        'status': 'completed',
        'completedAt': Timestamp.fromDate(now),
        'updatedAt': Timestamp.fromDate(now),
        'serverUpdatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e, s) {
      debugPrint('❌ completeBooking error: $e');
      debugPrintStack(stackTrace: s);
    }
  }

  Future<void> cancelBooking(
    String orderId, {
    String? reason,
  }) async {
    try {
      await _repo.updateOrder(orderId, {
        'status': 'cancelled',
        'cancelReason': reason ?? 'Cancelled by user',
        'updatedAt': Timestamp.fromDate(DateTime.now()),
        'serverUpdatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e, s) {
      debugPrint('❌ cancelBooking error: $e');
      debugPrintStack(stackTrace: s);
    }
  }
}
