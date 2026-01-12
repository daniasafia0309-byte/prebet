import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DriverModel {
  final String id;
  final String name;
  final double rating;

  double price; 

  final String car;
  final String plate;
  final String carColor;
  final Color avatarColor;
  final bool verified;
  final bool isAvailable;
  final String area;
  final double baseMultiplier;

  DriverModel({
    required this.id,
    required this.name,
    required this.rating,
    required this.price,
    required this.car,
    required this.plate,
    required this.carColor,
    required this.avatarColor,
    required this.verified,
    required this.isAvailable,
    required this.area,
    required this.baseMultiplier,
  });

  // from firestore
  factory DriverModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return DriverModel(
      id: doc.id,
      name: data['name'] ?? '',
      rating: (data['rating'] as num?)?.toDouble() ?? 0.0,
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
      car: data['car'] ?? '',
      plate: data['plate'] ?? '',
      carColor: data['carColor'] ?? '',
      avatarColor: Color(
        (data['avatarColor'] as int?) ?? Colors.grey.value,
      ),
      verified: data['verified'] ?? false,
      isAvailable: data['isAvailable'] ?? true,
      area: data['area'] ?? '',
      baseMultiplier:
          (data['baseMultiplier'] as num?)?.toDouble() ?? 1.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'rating': rating,
      'price': price,
      'car': car,
      'plate': plate,
      'carColor': carColor,
      'avatarColor': avatarColor.value,
      'verified': verified,
      'isAvailable': isAvailable,
      'area': area,
      'baseMultiplier': baseMultiplier,
    };
  }

  DriverModel copyWith({
    String? id,
    String? name,
    double? rating,
    double? price,
    String? car,
    String? plate,
    String? carColor,
    Color? avatarColor,
    bool? verified,
    bool? isAvailable,
    String? area,
    double? baseMultiplier,
  }) {
    return DriverModel(
      id: id ?? this.id,
      name: name ?? this.name,
      rating: rating ?? this.rating,
      price: price ?? this.price,
      car: car ?? this.car,
      plate: plate ?? this.plate,
      carColor: carColor ?? this.carColor,
      avatarColor: avatarColor ?? this.avatarColor,
      verified: verified ?? this.verified,
      isAvailable: isAvailable ?? this.isAvailable,
      area: area ?? this.area,
      baseMultiplier: baseMultiplier ?? this.baseMultiplier,
    );
  }
}
