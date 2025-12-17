import 'package:cloud_firestore/cloud_firestore.dart';


class AppUser {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String role;
  final String profileImage;
  final bool isActive;
  final double rating;
  final DateTime createdAt;

  AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.profileImage,
    required this.isActive,
    required this.rating,
    required this.createdAt,
  });
}

class DriverCard extends StatelessWidget {
  final String name;
  final double rating;
  final String car;
  final String carColor;
  final String price;
  final Color avatarColor;
  final bool verified;

  const DriverCard({
    super.key,
    required this.name,
    required this.rating,
    required this.car,
    required this.carColor,
    required this.price,
    required this.avatarColor,
    this.verified = false,
  });
}