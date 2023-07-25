import 'package:din/common/widgets/common_button.dart';
import 'package:din/constants/gaps.dart';
import 'package:din/project_detail.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CardsScreen extends StatefulWidget {
  const CardsScreen({super.key});

  @override
  State<CardsScreen> createState() => _CardsScreenState();
}

class _CardsScreenState extends State<CardsScreen> {
  late final PageController _pageController = PageController(
    viewportFraction: 0.8,
  )..addListener(() {
      if (_pageController.page == null) return;
      setState(() {
        _scroll.value = _pageController.page!;
      });
    });

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason>? _onCompleteTap() {
    return ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        showCloseIcon: true,
        content: Text('Please select a date'),
      ),
    );
    // Navigator.popUntil(context, (route) => route.isFirst);
  }

  int _currentPage = 0;

  final ValueNotifier<double> _scroll = ValueNotifier(0.0);

  void _onPageChange(int newPage) {
    setState(() {
      _currentPage = newPage;
    });
  }

  void _onProjectDetailTap(int index) {
    /* Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return FadeTransition(
            opacity: animation,
            child: ProjectDetailScreen(
              index: index,
            ),
          );
        },
      ),
    ); */

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProjectDetailScreen(index: index),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Create Project',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Stack(
        children: [
          // [ ] Blur처리된 Project의 배경화면
          // TODO 좀 더 고민해보고 결정 예정
          /* AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: Container(
              key: ValueKey(_currentPage),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/${_currentPage + 1}.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 20,
                  sigmaY: 20,
                ),
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                ),
              ),
            ),
          ), */
          PageView.builder(
            controller: _pageController,
            itemCount: 5,
            scrollDirection: Axis.horizontal,
            onPageChanged: _onPageChange,
            itemBuilder: (context, index) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ValueListenableBuilder(
                    valueListenable: _scroll,
                    builder: (context, scroll, child) {
                      final difference = (scroll - index).abs();
                      final scale = 1 - (difference * 0.13);

                      return GestureDetector(
                        onTap: () => _onProjectDetailTap(index + 1),
                        child: Transform.scale(
                          scale: scale,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                width: 0.5,
                                color: Colors.grey.shade400,
                              ),
                              borderRadius: BorderRadius.circular(5),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.15),
                                  blurRadius: 8,
                                  spreadRadius: 2,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(5),
                                    topRight: Radius.circular(5),
                                  ),
                                  child: Hero(
                                    tag: '${index + 1}',
                                    child: Container(
                                      width: 350,
                                      height: 350,
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color: Colors.grey.shade400,
                                            width: 0.5,
                                          ),
                                        ),
                                      ),
                                      child: Center(
                                        child: FaIcon(
                                          FontAwesomeIcons.image,
                                          size: 40,
                                          color: Colors.grey.shade400,
                                        ),
                                      ),
                                      /* child: Image(
                                        width: 350,
                                        height: 350,
                                        image: AssetImage(
                                          'assets/images/${index + 1}.jpg',
                                        ),
                                        fit: BoxFit.cover,
                                      ), */
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 320,
                                  child: Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Title",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.grey.shade500,
                                          ),
                                        ),
                                        Gaps.v10,
                                        SizedBox(
                                          height: 70,
                                          child: Text(
                                            "Description",
                                            style: TextStyle(
                                              color: Colors.grey.shade600,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Gaps.v10,
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 40),
                                  child: CommonButton(
                                    text: 'Edit',
                                    // bgColor: Colors.black,
                                    // color: Colors.white,
                                  ),
                                ),
                                /* Container(
                                  width: 180,
                                  padding: const EdgeInsets.all(18),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 0.5,
                                      color: Colors.grey.shade400,
                                    ),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Center(
                                    child: Text('Edit'),
                                  ),
                                ), */
                                Gaps.v20,
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  Gaps.v20,
                ],
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: CommonButton(
          text: 'Complete',
          bgColor: Colors.black,
          color: Colors.white,
          onTap: _onCompleteTap,
        ),
      ),
    );
  }
}
