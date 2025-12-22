import 'package:cloud_firestore/cloud_firestore.dart';

class Rating {
  final String bookingId;
  final String userId;
  final int rating; // 1 - 5
  final String? comment;
  final Timestamp createdAt;

  Rating({
    required this.bookingId,
    required this.userId,
    required this.rating,
    this.comment,
    required this.createdAt,
  });

  factory Rating.fromMap(
    Map<String, dynamic> map,
  ) {
    return Rating(
      bookingId: map['bookingId'] ?? '',
      userId: map['userId'] ?? '',
      rating: map['rating'] ?? 0,
      comment: map['comment'],
      createdAt: map['createdAt'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'bookingId': bookingId,
      'userId': userId,
      'rating': rating,
      'comment': comment,
      'createdAt': createdAt,
    };
  }
}
