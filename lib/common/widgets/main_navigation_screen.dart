import 'package:din/features/chart/chart_screen.dart';
import 'package:din/features/projects/cards_screen.dart';
import 'package:din/features/projects/create_project_first_screen.dart';
import 'package:din/features/projects/view_models/project_view_model.dart';
import 'package:din/features/projects/view_models/quote_screen.dart';
import 'package:din/features/users/profile_screen.dart';
import 'package:din/features/calendar/calendar_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  late int _difference = 0;

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
        const CalendarScreen(),
        const ChartScreen(),
        const ProfileScreen(),
      ];
    } else {
      await ref.read(projectProvider.notifier).loadUserProfile();
      final userUpdated = ref.watch(projectProvider);
      _pages = userUpdated!.hasProject
          ? [
              const CardsScreen(),
              const CalendarScreen(),
              const ChartScreen(),
              const ProfileScreen(),
            ]
          : [
              const CreateProjectFirstScreen(),
              const CalendarScreen(),
              const ChartScreen(),
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

  void _differeceDate(DateTime startDate) {
    DateTime currentDate = DateTime.now();
    int difference =
        currentDate.difference(startDate.add(const Duration(days: 1))).inDays;

    setState(() {
      _difference = difference;
    });
  }

  void _changePage(bool hasProject) {
    _pages = hasProject
        ? _difference == 0
            ? [
                const CardsScreen(),
                const CalendarScreen(),
                const ChartScreen(),
                const ProfileScreen(),
              ]
            : [
                const QuoteScreen(),
                const CalendarScreen(),
                const ChartScreen(),
                const ProfileScreen(),
              ]
        : [
            const CreateProjectFirstScreen(),
            const CalendarScreen(),
            const ChartScreen(),
            const ProfileScreen(),
          ];
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(projectProvider);
    final hasProject = user!.hasProject;
    final startDate = user.startDate;
    if (_hasProject != hasProject) {
      _hasProject = hasProject;
      _differeceDate(startDate!);
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
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              // backgroundColor: Colors.white,
              icon: Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: Icon(
                  _currentIndex == 0 ? Icons.home : Icons.home_outlined,
                  size: _currentIndex == 0 ? 28 : 26,
                ),
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: Icon(
                  _currentIndex == 1
                      ? Icons.calendar_month
                      : Icons.calendar_month_outlined,
                  size: _currentIndex == 1 ? 25 : 23,
                ),
              ),
              label: 'Calendar',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: Icon(
                  _currentIndex == 2
                      ? Icons.insert_chart
                      : Icons.insert_chart_outlined_outlined,
                  size: _currentIndex == 2 ? 25 : 23,
                ),
              ),
              label: 'Chart',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: Icon(
                  _currentIndex == 3 ? Icons.person : Icons.person_outline,
                  size: _currentIndex == 3 ? 28 : 26,
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
