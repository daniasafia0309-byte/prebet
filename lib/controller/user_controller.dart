import 'package:firebase_auth/firebase_auth.dart';
import '../repositories/user_repositories.dart';
import '../data/user_model.dart';

class UserController {
  final _repo = UserRepository();

  Future<AppUser?> getCurrentUser() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return null;
    return _repo.getUserById(uid);
  }
}
