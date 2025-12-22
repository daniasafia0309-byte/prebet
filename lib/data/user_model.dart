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

  factory AppUser.fromMap(
    String id,
    Map<String, dynamic> map,
  ) {
    return AppUser(
      id: id,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      role: map['role'] ?? 'user',
      profileImage: map['profileImage'] ?? '',
      isActive: map['isActive'] ?? true,
      rating: (map['rating'] ?? 0).toDouble(),
      createdAt: (map['createdAt'] is Timestamp)
          ? (map['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'role': role,
      'profileImage': profileImage,
      'isActive': isActive,
      'rating': rating,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
