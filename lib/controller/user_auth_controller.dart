import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserAuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final uid = cred.user!.uid;
      final int avatarIndex = Random().nextInt(4);

      // Save user profile
      await _db.collection('users').doc(uid).set({
        'uid': uid,
        'name': name.trim(),
        'email': email.trim(),
        'phone': phone.trim(),
        'avatarIndex': avatarIndex,
        'role': 'user',
        'membership': 'Gold',
        'points': 0,
        'totalRides': 0,
        'isActive': true,
        'rating': 0,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          throw 'Email is already registered';
        case 'invalid-email':
          throw 'Invalid email format';
        case 'weak-password':
          throw 'Password is too weak (minimum 6 characters)';
        case 'operation-not-allowed':
          throw 'Email/password login is not enabled';
        default:
          throw e.message ?? 'Registration failed';
      }
    } catch (e) {
      throw 'Registration failed. Please try again.';
    }
  }

  Future<void> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          throw 'No account found for this email';
        case 'wrong-password':
          throw 'Incorrect password';
        case 'invalid-email':
          throw 'Invalid email format';
        default:
          throw e.message ?? 'Login failed';
      }
    }
  }

  Future<void> logout() => _auth.signOut();

  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email.trim());
  }

  User? get currentUser => _auth.currentUser;

  Future<String?> getCurrentUserName() async {
    final user = currentUser;
    if (user == null) return null;

    final doc = await _db.collection('users').doc(user.uid).get();
    return doc.data()?['name'];
  }
}
