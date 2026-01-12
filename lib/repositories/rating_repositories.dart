import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prebet/data/rating_model.dart';

class RatingRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
 
  Future<void> addRating(Rating rating) async {
    await _firestore
        .collection('ratings')
        .add(rating.toMap());
  }

  Future<Rating?> getRatingByBooking(String bookingId) async {
    final query = await _firestore
        .collection('ratings')
        .where('bookingId', isEqualTo: bookingId)
        .limit(1)
        .get();

    if (query.docs.isEmpty) return null;

    return Rating.fromMap(query.docs.first.data());
  }

  Future<void> deleteRating(String ratingId) async {
    await _firestore
        .collection('ratings')
        .doc(ratingId)
        .delete();
  }
}
