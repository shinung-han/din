import 'dart:io';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:din/common/widgets/common_button.dart';
import 'package:din/constants/gaps.dart';
import 'package:din/constants/sizes.dart';
import 'package:din/features/calendar/view_models/calendar_view_model.dart';
import 'package:din/features/chart/view_model/chart_view_model.dart';
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
import 'package:go_router/go_router.dart';

class CardsScreen extends ConsumerStatefulWidget {
  const CardsScreen({super.key});

  @override
  ConsumerState<CardsScreen> createState() => _CardsScreenState();
}

class _CardsScreenState extends ConsumerState<CardsScreen> {
  void _requestTrackingAuthorization() async {
    if (Platform.isIOS) {
      await AppTrackingTransparency.requestTrackingAuthorization();
      // print(status);
    }
  }

  late final PageController _pageController = PageController(
    viewportFraction: 0.8,
  )..addListener(() {
      if (_pageController.page == null) return;
      setState(() {
        _scroll.value = _pageController.page!;
      });
    });

  double _rating = 3.0;

  // late List<Map<String, dynamic>> settingModalList;

  @override
  void initState() {
    super.initState();
    _requestTrackingAuthorization();
    // settingModalList = [
    //   {
    //     "text": "Edit project",
    //     "icon": Icons.build_outlined,
    //     "onTap": () => _onEditProjectTap(),
    //   },
    // ];
  }

  final ValueNotifier<double> _scroll = ValueNotifier(0.0);

  void _onCompleteGoalTap(String userId, String title, double rating) {
    ref.read(ratingProvider.notifier).saveRating(userId, title, rating);
    ref.read(dbGoalListProvider.notifier).updateRating(title, rating);
    final calendarViewModel = ref.read(calendarProvider.notifier);
    calendarViewModel.updateEventMemoOrRating(
        DateTime.now(), title, null, rating);
    ref.read(chartProvider.notifier).updateRating(title, rating);
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
    final goalsList = ref.watch(dbGoalListProvider);

    ref.watch(ratingProvider);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: ProjectAppBar(
        onPressed: () => context.go('/home/${EditProjectScreen.routeURL}'),
      ),
      body: goalsList.isEmpty
          ? const SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: Colors.black,
                  ),
                ],
              ),
            )
          : PageView.builder(
              controller: _pageController,
              itemCount: goalsList.length,
              scrollDirection: Axis.horizontal,
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
                                                image:
                                                    CachedNetworkImageProvider(
                                                  image!,
                                                ),
                                                fit: BoxFit.cover,
                                              ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Gaps.v16,
                                          Text(
                                            textAlign: TextAlign.center,
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
                                            itemBuilder: (context, _) =>
                                                const Icon(
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
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
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
                                                        backgroundColor:
                                                            Colors.white,
                                                        child: Icon(
                                                          Icons.edit_note,
                                                          size: 40,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Gaps.h10,
                                                  Expanded(
                                                    child: CommonButton(
                                                      text: '완료',
                                                      icon: Icons
                                                          .task_alt_rounded,
                                                      bgColor: Colors.black,
                                                      color: Colors.white,
                                                      onTap: () =>
                                                          _onCompleteTap(
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
                                                        backgroundColor:
                                                            Colors.white,
                                                        child: Icon(
                                                          Icons.edit_note,
                                                          size: 40,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Gaps.h10,
                                                  Expanded(
                                                    child: CommonButton(
                                                      text: '취소',
                                                      icon: Icons
                                                          .highlight_off_rounded,
                                                      bgColor: Colors.white,
                                                      color:
                                                          Colors.grey.shade400,
                                                      onTap: () =>
                                                          showModalBottomWithText(
                                                        context,
                                                        "완료를 취소하시겠습니까?",
                                                        () =>
                                                            _onCompleteGoalTap(
                                                                userId,
                                                                title,
                                                                0.0),
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

  // void _onEditProjectTap() {
  //   Navigator.pop(context);
  //   context.go('/home/${EditProjectScreen.routeURL}');
  // }

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
                        "목표를 달성하셨나요?",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: Sizes.size32,
                      child: Text("목표에 대한 만족도를 평가해 보세요"),
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
                          text: '예',
                          bgColor: Colors.black,
                          color: Colors.white,
                          onTap: () =>
                              _onCompleteGoalTap(userId, title, _rating)),
                    ),
                    Gaps.v16,
                    SizedBox(
                      height: 66,
                      child: CommonButton(
                        text: '취소',
                        bgColor: Colors.white,
                        color: Colors.black,
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
