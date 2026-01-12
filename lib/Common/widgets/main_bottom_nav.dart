import 'package:flutter/material.dart';
import 'package:prebet/common/app_colors.dart';

class MainBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const MainBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,

      selectedItemColor: AppColors.navbarActive,
      unselectedItemColor: AppColors.navbarInactive,

      iconSize: 24,
      selectedLabelStyle: const TextStyle(
        fontSize: 12,
        height: 1.6, 
      ),
      unselectedLabelStyle: const TextStyle(
        fontSize: 12,
        height: 1.6, 
      ),

      items: [
        const BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: 'Home',
        ),

        BottomNavigationBarItem(
          icon: SizedBox(
            width: 28,
            height: 28,
            child: ImageIcon(
              AssetImage('assets/icon/car.png'),
            ),
          ),
          activeIcon: SizedBox(
            width: 28,
            height: 28,
            child: ImageIcon(
              AssetImage('assets/icon/car.png'),
            ),
          ),
          label: 'My Rides',
        ),

        const BottomNavigationBarItem(
          icon: Icon(Icons.chat_bubble_outline),
          label: 'Chat',
        ),

        const BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: 'Profile',
        ),
      ],
    );
  }
}
