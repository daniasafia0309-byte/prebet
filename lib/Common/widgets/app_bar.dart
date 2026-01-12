import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prebet/common/app_colors.dart';

class PrebetAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final bool showLocation; // greeting switch
  final Widget? trailing;

  const PrebetAppBar({
    super.key,
    required this.title,
    this.showLocation = false,
    this.trailing,
  });

  @override
  Size get preferredSize => const Size.fromHeight(92);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: AppBar(
        elevation: 0,
        toolbarHeight: 76,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        flexibleSpace: _gradient(),
        titleSpacing: 16,
        title: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Row(
            children: [
              Expanded(
                child: showLocation
                    ? _greeting()
                    : _centerTitle(),
              ),
              if (trailing != null) trailing!,
            ],
          ),
        ),
      ),
    );
  }

  Widget _gradient() => Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primaryColor,
              Color(0xFF12A56B),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      );

  Widget _greeting() {
    final hour = DateTime.now().hour;
    late String greeting;

    if (hour < 12) {
      greeting = 'Good Morning ☀️';
    } else if (hour == 12) {
      greeting = 'Good Afternoon 🌤️';
    } else if (hour <= 18) {
      greeting = 'Good Evening 🌤️';
    } else {
      greeting = 'Good Night 🌙';
    }

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return _greetingText(greeting, 'User');
    }

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .snapshots(),
      builder: (context, snapshot) {
        String name = user.displayName ?? 'User';

        if (snapshot.hasData && snapshot.data!.exists) {
          final data =
              snapshot.data!.data() as Map<String, dynamic>;
          name = data['name'] ?? name;
        }

        return _greetingText(greeting, name);
      },
    );
  }

  Widget _greetingText(String greeting, String name) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          greeting,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          '$name!',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _centerTitle() => Center(
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
}
