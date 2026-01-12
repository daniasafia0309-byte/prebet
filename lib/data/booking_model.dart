import 'package:cloud_firestore/cloud_firestore.dart';

class BookingModel {
  final String id;
  final String userId;

  // Route
  final String pickup;
  final String destination;

  // Booking
  final String bookingDate;
  final String bookingTime;
  final int passenger;
  final double price;
  final int eta;

  // Status
  final String status;        
  final String paymentStatus; 
  final bool rated;

  // Driver
  final String? driverId;
  final String? driverName;
  final String? vehicleInfo;
  final int? driverAvatarColor;

  // Cancel
  final String? cancelReason;
  final String? cancelledBy;
  final Timestamp? cancelledAt;

  // Timestamp
  final Timestamp? createdAt;
  final Timestamp? updatedAt;
  final Timestamp? completedAt;

  BookingModel({
    required this.id,
    required this.userId,
    required this.pickup,
    required this.destination,
    required this.bookingDate,
    required this.bookingTime,
    required this.passenger,
    required this.price,
    required this.eta,
    required this.status,
    required this.paymentStatus,
    required this.rated,
    this.driverId,
    this.driverName,
    this.vehicleInfo,
    this.driverAvatarColor,
    this.cancelReason,
    this.cancelledBy,
    this.cancelledAt,
    this.createdAt,
    this.updatedAt,
    this.completedAt,
  });

  // firestore to model
  factory BookingModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? {};

    return BookingModel(
      id: doc.id,
      userId: data['userId'] ?? '',

      pickup: data['pickup'] ?? '',
      destination: data['destination'] ?? '',

      bookingDate: data['bookingDate'] ?? '',
      bookingTime: data['bookingTime'] ?? '',
      passenger: data['passenger'] ?? 1,

      price: (data['price'] as num?)?.toDouble() ?? 0.0,
      eta: data['eta'] ?? 0,

      status: data['status'] ?? 'pending',
      paymentStatus: data['paymentStatus'] ?? 'unpaid',
      rated: data['rated'] ?? false,

      driverId: data['driverId'],
      driverName: data['driverName'],
      vehicleInfo: data['vehicleInfo'],
      driverAvatarColor: data['driverAvatarColor'],

      cancelReason: data['cancelReason'],
      cancelledBy: data['cancelledBy'],
      cancelledAt: data['cancelledAt'],

      createdAt: data['createdAt'],
      updatedAt: data['updatedAt'],
      completedAt: data['completedAt'],
    );
  }

  // model to firestore
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'pickup': pickup,
      'destination': destination,
      'bookingDate': bookingDate,
      'bookingTime': bookingTime,
      'passenger': passenger,
      'price': price,
      'eta': eta,
      'status': status,
      'paymentStatus': paymentStatus,
      'rated': rated,
      'driverId': driverId,
      'driverName': driverName,
      'vehicleInfo': vehicleInfo,
      'driverAvatarColor': driverAvatarColor,
      'cancelReason': cancelReason,
      'cancelledBy': cancelledBy,
      'cancelledAt': cancelledAt,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'completedAt': completedAt,
    }..removeWhere((key, value) => value == null);
  }
}
