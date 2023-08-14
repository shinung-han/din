import 'package:din/features/projects/cards_screen.dart';
import 'package:din/features/projects/create_project_first_screen.dart';
import 'package:din/features/projects/view_models/project_view_model.dart';
import 'package:din/features/users/profile_screen.dart';
import 'package:din/list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class MainNavigationScreen extends ConsumerStatefulWidget {
  static String routeName = 'mainNavigation';

  final String? tab;

  const MainNavigationScreen({
    this.tab,
    super.key,
  });

  @override
  ConsumerState<MainNavigationScreen> createState() =>
      _MainNavigationScreenState();
}

class _MainNavigationScreenState extends ConsumerState<MainNavigationScreen> {
  final List<String> _tabs = [
    'home',
    'list',
    "chart",
    'profile',
  ];

  late int _currentIndex = _tabs.indexOf(widget.tab!);

  bool _hasProject = false;

  List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _loadPagesBasedOnUser();
  }

  Future<void> _loadPagesBasedOnUser() async {
    final user = ref.read(projectProvider);

    _hasProject = user!.hasProject;

    if (_hasProject) {
      _pages = [
        const CardsScreen(),
        const ListScreen(),
        const CardsScreen(),
        const ProfileScreen(),
      ];
    } else {
      await ref.read(projectProvider.notifier).loadUserProfile();
      final userUpdated = ref.watch(projectProvider);
      _pages = userUpdated!.hasProject
          ? [
              const CardsScreen(),
              const ListScreen(),
              const CardsScreen(),
              const ProfileScreen(),
            ]
          : [
              const CreateProjectFirstScreen(),
              const ListScreen(),
              const CardsScreen(),
              const ProfileScreen(),
            ];
    }

    setState(() {});
  }

  void _onTabTapped(int index) {
    context.go('/${_tabs[index]}');
    setState(() {
      _currentIndex = index;
    });
  }

  void _changePage(bool hasProject) {
    _pages = hasProject
        ? [
            const CardsScreen(),
            const ListScreen(),
            const CardsScreen(),
            const ProfileScreen(),
          ]
        : [
            const CreateProjectFirstScreen(),
            const ListScreen(),
            const CardsScreen(),
            const ProfileScreen(),
          ];
  }

  @override
  Widget build(BuildContext context) {
    final hasProject = ref.watch(projectProvider)!.hasProject;
    if (_hasProject != hasProject) {
      _hasProject = hasProject;
      _changePage(hasProject);
    }

    return Scaffold(
      body: _pages.isNotEmpty
          ? _pages[_currentIndex]
          : const Center(
              child: CircularProgressIndicator(),
            ),
      bottomNavigationBar: SizedBox(
        height: 110,
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          backgroundColor: Colors.white,
          elevation: 5,
          onTap: (value) => _onTabTapped(value),
          selectedItemColor: Colors.black,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
          showUnselectedLabels: true,
          unselectedItemColor: Colors.grey.shade500,
          unselectedFontSize: 13,
          items: [
            BottomNavigationBarItem(
              backgroundColor: Colors.white,
              icon: Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: FaIcon(
                  FontAwesomeIcons.house,
                  size: _currentIndex == 0 ? 18 : 16,
                ),
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: FaIcon(
                  FontAwesomeIcons.calendarCheck,
                  size: _currentIndex == 1 ? 18 : 16,
                ),
              ),
              label: 'Calendar',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: FaIcon(
                  FontAwesomeIcons.chartColumn,
                  size: _currentIndex == 2 ? 18 : 16,
                ),
              ),
              label: 'Chart',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: FaIcon(
                  FontAwesomeIcons.user,
                  size: _currentIndex == 3 ? 18 : 16,
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
