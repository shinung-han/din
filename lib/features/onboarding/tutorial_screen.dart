import 'package:din/common/widgets/common_button.dart';
import 'package:din/constants/gaps.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class TutorialScreen extends StatefulWidget {
  static const String routeName = 'tutorial';
  static const String routeURL = '/tutorial';

  const TutorialScreen({super.key});

  @override
  State<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  int _currentPage = 0;

  late final PageController _pageController = PageController(
    initialPage: _currentPage,
  )..addListener(
      () {
        int nextPage = _pageController.page!.round();
        if (_currentPage != nextPage) {
          setState(() {
            _currentPage = nextPage;
          });
        }
      },
    );

  void _handlePageChange(index) {
    _pageController.jumpToPage(index);
  }

  void _onNextTap() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
    );
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
          child: PageView(
            controller: _pageController,
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
          height: 140,
          child: Column(
            children: [
              SmoothPageIndicator(
                controller: _pageController,
                count: 4,
                effect: const ExpandingDotsEffect(
                  activeDotColor: Colors.black,
                  dotHeight: 12,
                  dotWidth: 12,
                ),
                onDotClicked: (index) => _handlePageChange(index),
              ),
              Gaps.v20,
              AnimatedOpacity(
                opacity: 1,
                duration: const Duration(milliseconds: 200),
                child: CommonButton(
                  text: _currentPage == 3 ? 'Enter the App' : 'Next',
                  color: Colors.white,
                  bgColor: Colors.black,
                  onTap: _currentPage == 3 ? _onEnterTheApp : _onNextTap,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
