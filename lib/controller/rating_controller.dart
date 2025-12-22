import 'package:prebet/lib/data/rating_model.dart';
import 'package:prebet/lib/repositories/rating_repositories.dart';

class RatingController {
  final RatingRepository _repository = RatingRepository();

  // =============================== STATE ===============================
  bool isLoading = false;
  Rating? rating;

  // =============================== LOAD RATING BY BOOKING ===============================
  Future<void> fetchRatingByBooking(String bookingId) async {
    isLoading = true;

    rating = await _repository.getRatingByBooking(bookingId);

    isLoading = false;
  }

  // =============================== CREATE RATING ===============================
  Future<void> addRating(Rating newRating) async {
    await _repository.addRating(newRating);
  }

  // =============================== DELETE RATING ===============================
  Future<void> deleteRating(String ratingId) async {
    await _repository.deleteRating(ratingId);
    rating = null;
  }
}
