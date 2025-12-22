import 'package:prebet/lib/data/booking_model.dart';
import 'package:prebet/lib/repositories/booking_repositories.dart';

class BookingController {
  final BookingRepository _repository = BookingRepository();

  // =============================== STATE ===============================
  bool isLoading = false;
  List<Booking> bookings = [];
  Booking? selectedBooking;

  // =============================== LOAD BOOKINGS BY USER ===============================
  Future<void> fetchBookingsByUser(String userId) async {
    isLoading = true;

    bookings = await _repository.getBookingsByUser(userId);

    isLoading = false;
  }

  // =============================== LOAD BOOKING BY ID ===============================
  Future<void> fetchBookingById(String bookingId) async {
    isLoading = true;

    selectedBooking = await _repository.getBookingById(bookingId);

    isLoading = false;
  }

  // =============================== CREATE NEW BOOKING ===============================
  Future<void> createBooking(Booking booking) async {
    await _repository.createBooking(booking);
  }

  // =============================== UPDATE BOOKING STATUS ===============================
  Future<void> updateBookingStatus(
    String bookingId,
    String status,
  ) async {
    await _repository.updateBookingStatus(bookingId, status);
  }

  // =============================== DELETE BOOKING ===============================
  Future<void> deleteBooking(String bookingId) async {
    await _repository.deleteBooking(bookingId);
    bookings.removeWhere((b) => b.id == bookingId);
  }
}
