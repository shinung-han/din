import 'package:din/common/widgets/common_button.dart';
import 'package:din/constants/gaps.dart';
import 'package:din/constants/sizes.dart';
import 'package:din/features/projects/view_models/db_goal_list_view_model.dart';
import 'package:din/features/projects/view_models/project_view_model.dart';
import 'package:din/features/projects/view_models/rating_view_model.dart';
import 'package:din/features/projects/widgets/app_bar.dart';
import 'package:din/project_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
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

  double _rating = 3.0;

  void _onCompleteTap(String userId, String title) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      elevation: 0,
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Gaps.v20,
                    const SizedBox(
                      height: Sizes.size32,
                      child: Text(
                        "Did you complete your goal?",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: Sizes.size32,
                      child: Text("Express your goal satisfaction"),
                    ),
                    Gaps.v20,
                    RatingBar.builder(
                      initialRating: 3,
                      itemCount: 5,
                      itemSize: 50,
                      allowHalfRating: true,
                      glow: false,
                      unratedColor: Colors.grey.shade300,
                      itemBuilder: (context, _) => const Icon(
                        Icons.star_rounded,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        setState(() {
                          _rating = rating;
                        });
                      },
                    ),
                    Gaps.v36,
                    SizedBox(
                      height: 66,
                      child: CommonButton(
                        icon: Icons.task_alt_rounded,
                        text: 'Yes',
                        onTap: () {
                          print(_rating);
                          ref
                              .read(ratingProvider.notifier)
                              .saveRating(userId, title, _rating);

                          ref
                              .read(dbGoalListProvider.notifier)
                              .updateRating(title, _rating);

                          Navigator.pop(context);
                        },
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
    ref.read(projectProvider.notifier).deleteProject(user.uid);
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
    // print(_rating);
    final user = ref.watch(projectProvider);
    final userId = user!.uid;
    // print(user.uid);

    final goalsList = ref.watch(dbGoalListProvider);
    ref.watch(ratingProvider);
    // print(goalsList);

    return Scaffold(
      appBar: ProjectAppBar(
        onPressed: _onSettingPressed,
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
            itemCount: goalsList.length,
            scrollDirection: Axis.horizontal,
            onPageChanged: _onPageChange,
            itemBuilder: (context, index) {
              final image = goalsList[index].image;
              final title = goalsList[index].title;
              final rating = goalsList[index].rating;

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ValueListenableBuilder(
                    valueListenable: _scroll,
                    builder: (context, scroll, child) {
                      final difference = (scroll - index).abs();
                      final scale = 1 - (difference * 0.13);

                      return Transform.scale(
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
                                  child: image == ""
                                      ? Icon(
                                          Icons.image_outlined,
                                          color: Colors.grey.shade300,
                                          size: 70,
                                        )
                                      : Image(
                                          width: 350,
                                          height: 350,
                                          image: NetworkImage(
                                            image!,
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Gaps.v20,
                                    Text(
                                      goalsList[index].title,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Gaps.v24,
                                    RatingBar.builder(
                                      initialRating: rating ?? 0,
                                      itemCount: 5,
                                      itemSize: 50,
                                      ignoreGestures: true,
                                      allowHalfRating: true,
                                      glow: false,
                                      unratedColor: Colors.grey.shade300,
                                      itemBuilder: (context, _) => const Icon(
                                        Icons.star_rounded,
                                        color: Colors.amber,
                                      ),
                                      onRatingUpdate: (rating) {
                                        setState(() {
                                          _rating = rating;
                                        });
                                      },
                                    ),
                                    Gaps.v20,
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: SizedBox(
                                  height: 60,
                                  child: CommonButton(
                                    text: 'Complete',
                                    icon: Icons.task_alt_rounded,
                                    bgColor: Colors.black,
                                    color: Colors.white,
                                    onTap: () => _onCompleteTap(userId, title),
                                  ),
                                ),
                              ),
                              Gaps.v16,
                            ],
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
                    SizedBox(
                      height: 66,
                      child: CommonButton(
                        text: 'Edit goal',
                        icon: Icons.build_outlined,
                        onTap: () {},
                      ),
                    ),
                    Gaps.v16,
                    SizedBox(
                      height: 66,
                      child: CommonButton(
                        text: 'Edit end date',
                        icon: Icons.edit_calendar_outlined,
                        onTap: () {},
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
