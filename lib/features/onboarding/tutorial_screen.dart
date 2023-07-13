import 'package:din/common/widgets/common_button.dart';
import 'package:din/constants/gaps.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TutorialScreen extends StatefulWidget {
  static const String routeName = 'tutorial';
  static const String routeURL = '/tutorial';

  const TutorialScreen({super.key});

  @override
  State<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController = TabController(
    length: 4,
    vsync: this,
  )..addListener(() {
      setState(() {
        _tabController = _tabController;
      });
    });

  void _onNextTap() {
    _tabController.index++;
  }

  void _onEnterTheApp() {
    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        body: SafeArea(
          child: TabBarView(
            controller: _tabController,
            children: const [
              Padding(
                padding: EdgeInsets.all(40),
                child: Column(
                  children: [
                    Gaps.v40,
                    Text(
                      'Choose your interests',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Videos are personalized for you based on wht you watch, like, and share.',
                    ),
                    Spacer(),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(40),
                child: Column(
                  children: [
                    Gaps.v40,
                    Text(
                      'Second Page',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Videos are personalized for you based on wht you watch, like, and share.',
                    ),
                    Spacer(),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(40),
                child: Column(
                  children: [
                    Gaps.v40,
                    Text(
                      'Third Page',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Videos are personalized for you based on wht you watch, like, and share.',
                    ),
                    Spacer(),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(40),
                child: Column(
                  children: [
                    Gaps.v40,
                    Text(
                      'Fourth Page',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Videos are personalized for you based on wht you watch, like, and share.',
                    ),
                    Spacer(),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.white,
          elevation: 0,
          height: 130,
          child: Column(
            children: [
              TabPageSelector(
                controller: _tabController,
              ),
              Gaps.v14,
              AnimatedOpacity(
                opacity: 1,
                duration: const Duration(milliseconds: 200),
                child: CommonButton(
                  text: _tabController.index == 3 ? 'Enter the App' : 'Next',
                  color: Colors.white,
                  bgColor: Colors.black,
                  onTap:
                      _tabController.index == 3 ? _onEnterTheApp : _onNextTap,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
