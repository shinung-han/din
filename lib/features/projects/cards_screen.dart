import 'package:din/common/widgets/common_button.dart';
import 'package:din/constants/gaps.dart';
import 'package:din/constants/sizes.dart';
import 'package:din/features/projects/view_models/project_view_model.dart';
import 'package:din/project_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CardsScreen extends ConsumerStatefulWidget {
  const CardsScreen({super.key});

  @override
  ConsumerState<CardsScreen> createState() => _CardsScreenState();
}

class _CardsScreenState extends ConsumerState<CardsScreen> {
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
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProjectDetailScreen(index: index),
        fullscreenDialog: true,
      ),
    );
  }

  void _onDeleteProject(user) {
    ref.read(projectProvider.notifier).updateHasProject(!user.hasProject);
    // Navigator.popUntil(
    //   context,
    //   ModalRoute.withName(ListOfGoalsScreen.routeURL),
    // );
    Navigator.pop(context);
    Navigator.pop(context);
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
          'D+23',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _onSettingPressed,
            icon: const Icon(
              Icons.settings,
              size: 28,
            ),
          )
        ],
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
                              borderRadius: BorderRadius.circular(28),
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
                                    topLeft: Radius.circular(28),
                                    topRight: Radius.circular(28),
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
                                      /* child: Center(
                                        child: FaIcon(
                                          FontAwesomeIcons.image,
                                          size: 40,
                                          color: Colors.grey.shade400,
                                        ),
                                      ), */
                                      child: Image(
                                        width: 350,
                                        height: 350,
                                        image: AssetImage(
                                          'assets/images/${index + 1}.jpg',
                                        ),
                                        fit: BoxFit.cover,
                                      ),
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
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child: SizedBox(
                                    height: 60,
                                    child: CommonButton(
                                      text: 'Complete',
                                      // icon: Icons.check_rounded,
                                      bgColor: Colors.black,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Gaps.v16,
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  Gaps.v32,
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  void _onSettingPressed() {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      builder: (context) {
        return Wrap(
          children: [
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: Sizes.size32,
                  left: Sizes.size16,
                  right: Sizes.size16,
                ),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 66,
                      child: CommonButton(
                        text: 'Edit goal',
                        icon: Icons.build_outlined,
                      ),
                    ),
                    Gaps.v16,
                    const SizedBox(
                      height: 66,
                      child: CommonButton(
                        text: 'End date change',
                        icon: Icons.edit_calendar_outlined,
                      ),
                    ),
                    Gaps.v16,
                    SizedBox(
                      height: 66,
                      child: CommonButton(
                        icon: Icons.remove_circle_outline_rounded,
                        text: 'Delete Project',
                        onTap: _onDeleteProjectTap,
                      ),
                    ),
                    Gaps.v16,
                    SizedBox(
                      height: 66,
                      child: CommonButton(
                        text: 'Cancel',
                        bgColor: Colors.black,
                        color: Colors.white,
                        icon: Icons.arrow_back_ios_new_rounded,
                        onTap: () => Navigator.pop(context),
                      ),
                    ),
                    Gaps.v12,
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _onDeleteProjectTap() {
    final user = ref.watch(projectProvider);

    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      builder: (context) {
        return Wrap(
          children: [
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: Sizes.size20,
                  left: Sizes.size16,
                  right: Sizes.size16,
                ),
                child: Column(
                  children: [
                    Gaps.v20,
                    const SizedBox(
                      height: 50,
                      child: Text(
                        "Are you sure you want to delete the project?",
                        style: TextStyle(
                          fontSize: 17,
                        ),
                      ),
                    ),
                    Gaps.v20,
                    SizedBox(
                      height: 66,
                      child: CommonButton(
                        icon: Icons.remove_circle_outline_rounded,
                        text: 'Yes',
                        onTap: () => _onDeleteProject(user),
                      ),
                    ),
                    Gaps.v16,
                    SizedBox(
                      height: 66,
                      child: CommonButton(
                        text: 'Cancel',
                        bgColor: Colors.black,
                        color: Colors.white,
                        icon: Icons.arrow_back_ios_new_rounded,
                        onTap: () => Navigator.pop(context),
                      ),
                    ),
                    Gaps.v12,
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
