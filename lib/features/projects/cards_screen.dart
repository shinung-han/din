import 'package:din/common/widgets/common_button.dart';
import 'package:din/constants/gaps.dart';
import 'package:din/constants/sizes.dart';
import 'package:din/features/projects/edit_project_screen.dart';
import 'package:din/features/projects/memo_screen.dart';
import 'package:din/features/projects/view_models/db_goal_list_view_model.dart';
import 'package:din/features/projects/view_models/project_view_model.dart';
import 'package:din/features/projects/view_models/rating_view_model.dart';
import 'package:din/features/projects/widgets/app_bar.dart';
import 'package:din/utils.dart';
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

  final int _currentPage = 0;

  final ValueNotifier<double> _scroll = ValueNotifier(0.0);

  // void _onPageChange(int newPage) {
  //   setState(() {
  //     _currentPage = newPage;
  //   });
  // }

  // void _onProjectDetailTap(int index) {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => ProjectDetailScreen(index: index),
  //       fullscreenDialog: true,
  //     ),
  //   );
  // }

  // void _onDeleteProject(user) {
  //   ref.read(projectProvider.notifier).updateHasProject(!user.hasProject);
  //   ref.read(projectProvider.notifier).deleteProject(user.uid);
  //   Navigator.pop(context);
  //   Navigator.pop(context);
  // }

  void _onCompleteGoalTap(String userId, String title, double rating) {
    ref.read(ratingProvider.notifier).saveRating(userId, title, rating);
    ref.read(dbGoalListProvider.notifier).updateRating(title, rating);
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(projectProvider);
    final userId = user!.uid;
    // print(user.uid);

    final goalsList = ref.watch(dbGoalListProvider);
    ref.watch(ratingProvider);
    // print(goalsList);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: ProjectAppBar(
        onPressed: () => showModalBottom(context, settingModalList),
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: goalsList.length,
        scrollDirection: Axis.horizontal,
        // onPageChanged: _onPageChange,
        itemBuilder: (context, index) {
          final image = goalsList[index].image;
          final title = goalsList[index].title;
          final rating = goalsList[index].rating;
          final memo = goalsList[index].memo;

          return Center(
            child: SingleChildScrollView(
              child: Column(
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
                                    Gaps.v16,
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
                                      itemSize: 40,
                                      ignoreGestures: true,
                                      allowHalfRating: true,
                                      glow: false,
                                      unratedColor: Colors.grey.shade200,
                                      itemBuilder: (context, _) => const Icon(
                                        Icons.star_rounded,
                                        color: Colors.amber,
                                      ),
                                      onRatingUpdate: (rating) {},
                                    ),
                                    Gaps.v16,
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: SizedBox(
                                  height: 60,
                                  child: rating == 0
                                      ? Row(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        MemoScreen(
                                                      userId: userId,
                                                      title: title,
                                                      memo: memo ?? "",
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: CircleAvatar(
                                                radius: 30,
                                                backgroundColor:
                                                    Colors.grey.shade400,
                                                child: const CircleAvatar(
                                                  radius: 29.5,
                                                  backgroundColor: Colors.white,
                                                  child: Icon(
                                                    Icons.notes_rounded,
                                                    size: 30,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Gaps.h10,
                                            Expanded(
                                              child: CommonButton(
                                                text: 'Complete',
                                                icon: Icons.task_alt_rounded,
                                                bgColor: Colors.black,
                                                color: Colors.white,
                                                onTap: () => _onCompleteTap(
                                                    userId, title),
                                              ),
                                            ),
                                          ],
                                        )
                                      : Row(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        MemoScreen(
                                                      userId: userId,
                                                      title: title,
                                                      memo: memo ?? "",
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: CircleAvatar(
                                                radius: 30,
                                                backgroundColor:
                                                    Colors.grey.shade400,
                                                child: const CircleAvatar(
                                                  radius: 29.5,
                                                  backgroundColor: Colors.white,
                                                  child: Icon(
                                                    Icons.notes_rounded,
                                                    size: 30,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Gaps.h10,
                                            Expanded(
                                              child: CommonButton(
                                                text: 'Cancel',
                                                icon:
                                                    Icons.highlight_off_rounded,
                                                bgColor: Colors.white,
                                                color: Colors.grey.shade400,
                                                onTap: () =>
                                                    showModalBottomWithText(
                                                  context,
                                                  "Are you sure you want to cancel?",
                                                  () => _onCompleteGoalTap(
                                                      userId, title, 0.0),
                                                ),
                                              ),
                                            ),
                                          ],
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
              ),
            ),
          );
        },
      ),
    );
  }

  List<Map<String, dynamic>> settingModalList = [
    {
      "text": "Edit project",
      "icon": Icons.build_outlined,
      "onTap": (context) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const EditProjectScreen(),
          ),
        );
      }
    },
  ];

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
                    Gaps.v14,
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
                          onTap: () =>
                              _onCompleteGoalTap(userId, title, _rating)),
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
