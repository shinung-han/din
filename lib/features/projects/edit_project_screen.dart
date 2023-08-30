import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:din/common/widgets/main_navigation_screen.dart';
import 'package:din/constants/gaps.dart';
import 'package:din/constants/sizes.dart';
import 'package:din/features/calendar/view_models/calendar_view_model.dart';
import 'package:din/features/projects/edit_db_title_screen.dart';
import 'package:din/features/projects/models/db_goal_model.dart';
import 'package:din/features/projects/view_models/app_bar_view_model.dart';
import 'package:din/features/projects/view_models/db_edit_image_view_model.dart';
import 'package:din/features/projects/view_models/db_goal_list_view_model.dart';
import 'package:din/features/projects/view_models/goal_list_view_model.dart';
import 'package:din/features/projects/view_models/project_view_model.dart';
import 'package:din/features/projects/widgets/date_information.dart';
import 'package:din/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class EditProjectScreen extends ConsumerStatefulWidget {
  static const routeName = 'edit_project';
  static const routeURL = 'edit_project';

  const EditProjectScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditProjectScreenState();
}

class _EditProjectScreenState extends ConsumerState<EditProjectScreen> {
  void _onDeleteProject(user) {
    ref
        .read(projectProvider.notifier)
        .updateHasProject(!user.hasProject, DateTime.now());

    ref.read(projectProvider.notifier).deleteProject(user.uid);

    ref.read(goalListProvider.notifier).deleteAllGoals(context);

    Navigator.popUntil(
        context, ModalRoute.withName(MainNavigationScreen.routeName));
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(projectProvider);
    final date = ref.watch(appBarProvider);
    final goalsList = ref.watch(dbGoalListProvider);

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              title: const Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.only(left: Sizes.size24),
                  child: Text(
                    'Edit project',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: Sizes.size5),
                  child: IconButton(
                    onPressed: () => showModalBottomWithText(
                      context,
                      "Are you sure you want to delete the project?",
                      () => _onDeleteProject(user),
                    ),
                    icon: const Icon(
                      Icons.remove_circle_outline_rounded,
                      size: 30,
                    ),
                  ),
                ),
              ],
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(
                          top: 10,
                          left: 15,
                          bottom: 10,
                        ),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Date information",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      DateInformation(date: date!),
                      Gaps.v20,
                      divider(),
                    ],
                  ),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 10,
                ),
                child: Text(
                  "Goal list",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            goalsList.isEmpty
                ? SliverFillRemaining(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Colors.black,
                      ),
                    ),
                  )
                : SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final image = goalsList[index].image;
                        final title = goalsList[index].title;

                        return Column(
                          children: [
                            GoalListTile(
                              userId: user!.uid,
                              title: title,
                              image: image ?? '',
                              goalList: goalsList,
                            ).animate(delay: 100.milliseconds).flipV(
                                  begin: -0.5,
                                  end: 0,
                                  curve: Curves.easeOutExpo,
                                ),
                            Gaps.v8,
                          ],
                        );
                      }, childCount: goalsList.length),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

class GoalListTile extends ConsumerStatefulWidget {
  final String userId;
  final String title;
  final String image;
  final List<DbGoalModel> goalList;

  const GoalListTile({
    super.key,
    required this.userId,
    required this.title,
    required this.image,
    required this.goalList,
  });

  @override
  ConsumerState<GoalListTile> createState() => _GoalListTileState();
}

class _GoalListTileState extends ConsumerState<GoalListTile> {
  late List<Map<String, dynamic>> goalModalList;

  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    goalModalList = [
      {
        "text": "Edit image",
        "icon": Icons.image_search_rounded,
        "onTap": () => _onEditImage(widget.userId, widget.image),
      },
      {
        "text": "Edit title",
        "icon": Icons.build_outlined,
        "onTap": _onEditTitleTap
      },
    ];
  }

  Future<void> _onEditImage(String userId, String oldImageUrl) async {
    final pickedFile = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 100,
      maxHeight: 500,
      maxWidth: 500,
    );

    if (!mounted) return;

    if (pickedFile != null) {
      final currentContext = context;

      Navigator.popUntil(
          currentContext, ModalRoute.withName(EditProjectScreen.routeURL));

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            content: Container(
              height: 130,
              color: Colors.white,
              width: MediaQuery.of(context).size.width * 0.55,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Colors.black),
                  Gaps.v16,
                  Text("Editing image.."),
                ],
              ),
            ),
          );
        },
      );

      final newImageUrl = await ref.read(editImageProvider.notifier).editImage(
            userId,
            widget.title,
            oldImageUrl,
            File(pickedFile.path),
          );

      ref
          .read(dbGoalListProvider.notifier)
          .updateImage(widget.title, oldImageUrl, newImageUrl);

      ref.read(calendarProvider.notifier).updateAllEventsTitleAndImage(
          widget.title, null, oldImageUrl, newImageUrl);

      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  void _onEditTitleTap() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditDbTitleScreen(
          title: widget.title,
          goalList: widget.goalList,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
            width: 0.5,
            color: Colors.grey.shade400,
          ),
          borderRadius: BorderRadius.circular(10)),
      child: SizedBox(
        height: 80,
        child: Row(
          children: [
            widget.image != ""
                ? Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                      ),
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(
                          widget.image,
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                : SizedBox(
                    width: 80,
                    height: 80,
                    child: Center(
                      child: Icon(
                        Icons.image_outlined,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: Sizes.size14,
                ),
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      color: Colors.grey.shade400,
                      width: 0.5,
                    ),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                onPressed: () => showModalBottom(context, goalModalList),
                icon: const Icon(Icons.more_vert_rounded),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
