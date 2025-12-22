import 'package:cloud_firestore/cloud_firestore.dart';

class Booking {
  final String id;
  final String userId;
  final String driverId;
  final String status; // pending, completed, cancelled
  final double fare;
  final Timestamp createdAt;

  Booking({
    required this.id,
    required this.userId,
    required this.driverId,
    required this.status,
    required this.fare,
    required this.createdAt,
  });

  factory Booking.fromMap(
    String id,
    Map<String, dynamic> map,
  ) {
    return Booking(
      id: id,
      userId: map['userId'] ?? '',
      driverId: map['driverId'] ?? '',
      status: map['status'] ?? 'pending',
      fare: (map['fare'] ?? 0).toDouble(),
      createdAt: map['createdAt'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'driverId': driverId,
      'status': status,
      'fare': fare,
      'createdAt': createdAt,
    };
  }
}
