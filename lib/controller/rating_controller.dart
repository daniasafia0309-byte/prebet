import 'package:prebet/data/rating_model.dart';
import 'package:prebet/repositories/rating_repositories.dart';

class RatingController {
  final RatingRepository _repository = RatingRepository();

  // State
  bool isLoading = false;
  Rating? rating;

  Future<void> fetchRatingByBooking(String bookingId) async {
    isLoading = true;

    rating = await _repository.getRatingByBooking(bookingId);

    isLoading = false;
  }

  // Create rating
  Future<void> addRating(Rating newRating) async {
    await _repository.addRating(newRating);
  }

  // Delete rating 
  Future<void> deleteRating(String ratingId) async {
    await _repository.deleteRating(ratingId);
    rating = null;
  }
}
