import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prebet/data/user_model.dart';

class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // CREATE / UPDATE USER 
  Future<void> saveUser(AppUser user) async {
    await _firestore
        .collection('users')
        .doc(user.id)
        .set(user.toMap());
  }

  // GET USER BY ID 
  Future<AppUser?> getUserById(String userId) async {
    final doc = await _firestore
        .collection('users')
        .doc(userId)
        .get();

    if (!doc.exists) return null;

    return AppUser.fromMap(doc.id, doc.data()!);
  }

  // UPDATE USER STATUS
  Future<void> updateUserStatus(
    String userId,
    bool isActive,
  ) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .update({'isActive': isActive});
  }

  // UPDATE USER PROFILE IMAGE
  Future<void> updateProfileImage(
    String userId,
    String imageUrl,
  ) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .update({'profileImage': imageUrl});
  }

  // DELETE USER 
  Future<void> deleteUser(String userId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .delete();
  }
}
