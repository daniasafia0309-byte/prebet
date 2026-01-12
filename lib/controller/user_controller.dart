import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prebet/data/user_model.dart';

class UserController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<AppUser?> getCurrentUser() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return null;

    final docRef = _firestore.collection('users').doc(uid);
    final snapshot = await docRef.get();

    if (!snapshot.exists) return null;

    final data = snapshot.data() as Map<String, dynamic>;

    if (!data.containsKey('avatarIndex')) {
      final int randomAvatarIndex = Random().nextInt(4);
      await docRef.update({'avatarIndex': randomAvatarIndex});
      data['avatarIndex'] = randomAvatarIndex;
    }

    // Safety
    data['avatarIndex'] =
        (data['avatarIndex'] as int).clamp(0, 3);

    return AppUser.fromMap(uid, data);
  }

  Future<void> completeRide({bool isPromo = false}) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    final userRef = _firestore.collection('users').doc(uid);

    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(userRef);
      if (!snapshot.exists) return;

      final data = snapshot.data() as Map<String, dynamic>;

      final int currentRides = data['totalRides'] ?? 0;
      final int currentPoints = data['points'] ?? 0;
      final String currentMembership = data['membership'] ?? 'Silver';

      int addedPoints = 2; 

      if (currentRides == 0) {
        addedPoints += 5;
      }

      if (isPromo) {
        addedPoints += 2;
      }

      final int updatedRides = currentRides + 1;
      final int updatedPoints = currentPoints + addedPoints;

      String newMembership = currentMembership;

      if (updatedPoints >= 100 &&
          currentMembership != 'Platinum') {
        newMembership = 'Platinum';
      } else if (updatedPoints >= 50 &&
          currentMembership == 'Silver') {
        newMembership = 'Gold';
      }

      transaction.update(userRef, {
        'totalRides': updatedRides,
        'points': updatedPoints,
        'membership': newMembership,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    });
  }
}
