import 'package:flutter/material.dart';
import 'package:prebet/common/widgets/app_bar.dart';
import 'package:prebet/common/widgets/main_bottom_nav.dart';
import 'package:prebet/screens/home/homepage.dart';
import 'package:prebet/screens/my_rides.dart';
import 'package:prebet/screens/messages/chat.dart';
import 'package:prebet/screens/profile/profile.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  static _MainLayoutState? of(BuildContext context) {
    return context.findAncestorStateOfType<_MainLayoutState>();
  }

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;
  bool _initializedFromArgs = false;

  final List<Widget> _pages = const [
    HomePage(),
    MyRidesPage(),
    ChatPage(),
    ProfilePage(),
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_initializedFromArgs) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is int && args >= 0 && args < _pages.length) {
        _currentIndex = args;
      }
      _initializedFromArgs = true;
    }
  }

  void goToProfile() {
    setState(() => _currentIndex = 3);
  }

  PreferredSizeWidget _buildAppBar() {
    switch (_currentIndex) {
      case 0:
        return const PrebetAppBar(
          title: '',
          showLocation: true, 
        );
      case 1:
        return const PrebetAppBar(
          title: 'My Rides',
        );
      case 2:
        return const PrebetAppBar(
          title: 'Messages', 
        );
      case 3:
        return const PrebetAppBar(
          title: 'Profile',
        );
      default:
        return const PrebetAppBar(title: '');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: MainBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
      ),
    );
  }
}
