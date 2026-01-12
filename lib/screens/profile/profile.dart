import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:prebet/common/app_colors.dart';
import 'package:prebet/common/widgets/user_avatar.dart';
import 'package:prebet/screens/auth/logout.dart';
import 'package:prebet/screens/profile/edit_profile.dart';
import 'package:prebet/screens/profile/help_support.dart';
import 'package:prebet/data/user_model.dart';
import 'package:prebet/main.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  AppUser? _user;

  int _totalRides = 0;
  int _points = 0;
  String _membership = 'Bronze';

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser == null) return;

    final userSnap = await FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseUser.uid)
        .get();

    if (!userSnap.exists) return;
    _user = AppUser.fromFirestore(userSnap);

    final ridesSnap = await FirebaseFirestore.instance
        .collection('bookings')
        .where('userId', isEqualTo: firebaseUser.uid)
        .where('status', isEqualTo: 'completed')
        .get();

    _totalRides = ridesSnap.docs.length;
    _points = _totalRides * 2;

    if (_points >= 100) {
      _membership = 'Gold';
    } else if (_points >= 50) {
      _membership = 'Silver';
    } else {
      _membership = 'Bronze';
    }

    if (mounted) setState(() {});
  }

  double get _progress {
    final target = _membership == 'Bronze' ? 50 : 100;
    return (_points / target).clamp(0.0, 1.0);
  }

  Color get _membershipColor {
    switch (_membership) {
      case 'Gold':
        return Colors.orange;
      case 'Silver':
        return Colors.blueGrey;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 20),
                child: Column(
                  children: [
                    _profileCard(),
                    const SizedBox(height: 20),
                    _settings(),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                16,
                16,
                16,
                -20 + kBottomNavigationBarHeight,
              ),
              child: const LogoutButton(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _profileCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF00C9A7),
            Color(0xFF007C6D),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              UserAvatar(user: _user!, size: 68),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _user!.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    _user!.studentId,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),
          _membershipBadge(),
          const SizedBox(height: 18),

          Row(
            children: [
              _StatBox(
                title: 'Total Rides',
                value: _totalRides,
                borderColor: _membershipColor,
              ),
              const SizedBox(width: 14),
              _StatBox(
                title: 'Points',
                value: _points,
                borderColor: _membershipColor,
              ),
            ],
          ),

          const SizedBox(height: 18),
          _progressBar(),
        ],
      ),
    );
  }

  Widget _membershipBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
      decoration: BoxDecoration(
        color: _membershipColor,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.emoji_events, color: Colors.white, size: 15),
          const SizedBox(width: 6),
          Text(
            '$_membership Member',
            style: const TextStyle(color: Colors.white, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _progressBar() {
    final target = _membership == 'Bronze' ? 50 : 100;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Progress to ${_membership == 'Bronze' ? 'Silver' : 'Gold'}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          '$_points / $target points',
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
        const SizedBox(height: 10),

        Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(0.6),
              width: 1.3,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: SizedBox(
              height: 14,
              child: LinearProgressIndicator(
                value: _progress,
                backgroundColor: Colors.white24,
                valueColor: AlwaysStoppedAnimation(_membershipColor),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _settings() {
    return Column(
      children: [
        _settingTile(
          icon: Icons.edit,
          color: Colors.blue,
          title: 'Edit Profile',
          onTap: () async {
            await navigatorKey.currentState!.push(
              MaterialPageRoute(
                builder: (_) => EditProfilePage(user: _user!),
              ),
            );
            _loadProfile();
          },
        ),
        _settingTile(
          icon: Icons.help_outline,
          color: Colors.orange,
          title: 'Help & Support',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const HelpSupportPage(),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _settingTile({
    required IconData icon,
    required Color color,
    required String title,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          radius: 22,
          backgroundColor: color.withOpacity(0.15),
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String title;
  final int value;
  final Color borderColor;

  const _StatBox({
    required this.title,
    required this.value,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: borderColor,
            width: 3,
          ),
        ),
        child: Column(
          children: [
            Text(
              value.toString(),
              style: const TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              title,
              style: TextStyle(
                fontSize: 13,
                color: borderColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
