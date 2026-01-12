import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String id; 
  final String name;
  final String email;
  final String phone;
  final String studentId;
  final String role;
  final bool isActive;
  final double rating;
  final String profileImage;

  final String emergencyName;
  final String emergencyPhone;
  final String emergencyRelationship;

  // Ride & Reward
  final int totalRides;
  final int points;
  final String membership;

  final int avatarIndex;
  final DateTime createdAt;

  AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.studentId,
    required this.role,
    required this.profileImage,
    required this.isActive,
    required this.rating,
    required this.emergencyName,
    required this.emergencyPhone,
    required this.emergencyRelationship,
    required this.totalRides,
    required this.points,
    required this.membership,
    required this.avatarIndex,
    required this.createdAt,
  });

  // from firestore
  factory AppUser.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();
    if (data == null) {
      throw Exception('User document is empty');
    }
    return AppUser.fromMap(doc.id, data);
  }

  // from map
  factory AppUser.fromMap(String id, Map<String, dynamic> map) {
    final int rawAvatarIndex = map['avatarIndex'] ?? 0;

    return AppUser(
      id: id,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      studentId: map['studentId'] ?? '',

      role: map['role'] ?? 'user',
      profileImage: map['profileImage'] ?? '',
      isActive: map['isActive'] ?? true,
      rating: (map['rating'] ?? 0).toDouble(),

      emergencyName: map['emergencyName'] ?? '',
      emergencyPhone: map['emergencyPhone'] ?? '',
      emergencyRelationship: map['emergencyRelationship'] ?? 'Parent',

      totalRides: map['totalRides'] ?? 0,
      points: map['points'] ?? 0,
      membership: map['membership'] ?? 'Bronze',

      avatarIndex: rawAvatarIndex.clamp(0, 3),

      createdAt: (map['createdAt'] is Timestamp)
          ? (map['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  // to firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'studentId': studentId,
      'role': role,
      'profileImage': profileImage,
      'isActive': isActive,
      'rating': rating,

      'emergencyName': emergencyName,
      'emergencyPhone': emergencyPhone,
      'emergencyRelationship': emergencyRelationship,

      'totalRides': totalRides,
      'points': points,
      'membership': membership,

      'avatarIndex': avatarIndex,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  AppUser copyWith({
    String? name,
    String? email,
    String? phone,
    String? profileImage,
    String? emergencyName,
    String? emergencyPhone,
    String? emergencyRelationship,
    int? totalRides,
    int? points,
    String? membership,
    int? avatarIndex,
  }) {
    return AppUser(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      studentId: studentId,

      role: role,
      profileImage: profileImage ?? this.profileImage,
      isActive: isActive,
      rating: rating,

      emergencyName: emergencyName ?? this.emergencyName,
      emergencyPhone: emergencyPhone ?? this.emergencyPhone,
      emergencyRelationship:
          emergencyRelationship ?? this.emergencyRelationship,

      totalRides: totalRides ?? this.totalRides,
      points: points ?? this.points,
      membership: membership ?? this.membership,

      avatarIndex: avatarIndex ?? this.avatarIndex,
      createdAt: createdAt,
    );
  }
}
