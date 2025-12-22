import 'package:cloud_firestore/cloud_firestore.dart';

class DriverModel {
  final String id;
  final String name;
  final double rating;
  final String car;
  final String carColor;
  final double price;
  final bool verified;
  final bool isAvailable;

  DriverModel({
    required this.id,
    required this.name,
    required this.rating,
    required this.car,
    required this.carColor,
    required this.price,
    required this.verified,
    required this.isAvailable,
  });

  factory DriverModel.fromMap(
    String id,
    Map<String, dynamic> map,
  ) {
    return DriverModel(
      id: id,
      name: map['name'] ?? '',
      rating: (map['rating'] ?? 0).toDouble(),
      car: map['car'] ?? '',
      carColor: map['carColor'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      verified: map['verified'] ?? false,
      isAvailable: map['isAvailable'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'rating': rating,
      'car': car,
      'carColor': carColor,
      'price': price,
      'verified': verified,
      'isAvailable': isAvailable,
      'updatedAt': Timestamp.now(),
    };
  }
}
