import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prebet/lib/data/booking_model.dart';

class BookingRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // CREATE BOOKING 
  Future<void> createBooking(Booking booking) async {
    await _firestore
        .collection('bookings')
        .doc(booking.id)
        .set(booking.toMap());
  }

  // GET BOOKINGS BY USER 
  Future<List<Booking>> getBookingsByUser(String userId) async {
    final query = await _firestore
        .collection('bookings')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .get();

    return query.docs.map((doc) {
      return Booking.fromMap(doc.id, doc.data());
    }).toList();
  }

  // GET BOOKING BY ID 
  Future<Booking?> getBookingById(String bookingId) async {
    final doc = await _firestore
        .collection('bookings')
        .doc(bookingId)
        .get();

    if (!doc.exists) return null;

    return Booking.fromMap(doc.id, doc.data()!);
  }

  // UPDATE BOOKING STATUS 
  Future<void> updateBookingStatus(
    String bookingId,
    String status,
  ) async {
    await _firestore
        .collection('bookings')
        .doc(bookingId)
        .update({'status': status});
  }

  // DELETE BOOKING 
  Future<void> deleteBooking(String bookingId) async {
    await _firestore
        .collection('bookings')
        .doc(bookingId)
        .delete();
  }
}
