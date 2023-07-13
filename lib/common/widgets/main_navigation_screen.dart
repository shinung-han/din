import 'package:din/features/projects/project_screen.dart';
import 'package:din/features/users/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class MainNavigationScreen extends StatefulWidget {
  static String routeName = 'mainNavigation';

  final String? tab;

  const MainNavigationScreen({
    this.tab,
    super.key,
  });

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  final List<String> _tabs = [
    'home',
    'list',
    'profile',
  ];

  late int _currentIndex = _tabs.indexOf(widget.tab!);

  final List<Widget> _pages = [
    const ProjectScreen(),
    const Screen2(),
    const ProfileScreen(),
  ];

  void _onTabTapped(int index) {
    context.go('/${_tabs[index]}');
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Main Navigation Screen'),
      // ),
      body: _pages[_currentIndex],
      bottomNavigationBar: SizedBox(
        height: 110,
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          currentIndex: _currentIndex,
          elevation: 1,
          onTap: (value) => _onTabTapped(value),
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey.shade500,
          unselectedFontSize: 13,
          items: [
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: FaIcon(
                  FontAwesomeIcons.house,
                  size: _currentIndex == 0 ? 18 : 16,
                ),
              ),
              label: 'Home',
            ),
            const BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 5),
                child: FaIcon(
                  FontAwesomeIcons.list,
                  size: 16,
                ),
              ),
              label: 'List',
            ),
            const BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 5),
                child: FaIcon(
                  FontAwesomeIcons.user,
                  size: 16,
                ),
              ),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}

class Screen1 extends StatelessWidget {
  const Screen1({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Screen 1'),
    );
  }
}

class Screen2 extends StatelessWidget {
  const Screen2({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Screen 2'),
    );
  }
}
