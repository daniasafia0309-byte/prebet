import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:prebet/data/user_model.dart';

class UserProfileController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<AppUser?> getProfile() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return null;

    final doc = await _db.collection('users').doc(uid).get();
    if (!doc.exists || doc.data() == null) return null;

    return AppUser.fromMap(uid, doc.data()!);
  }

  // Update profile
  Future<void> updateProfile(AppUser user) async {
    await _db.collection('users').doc(user.id).update({
      'name': user.name,
      'email': user.email,
      'phone': user.phone,
      'profileImage': user.profileImage,
      'emergencyName': user.emergencyName,
      'emergencyPhone': user.emergencyPhone,
      'emergencyRelationship': user.emergencyRelationship,
    });
  }

  // update student ID
  Future<void> updateStudentId(String studentId) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    await _db.collection('users').doc(uid).update({
      'studentId': studentId,
    });
  }
}
