import 'dart:io';

import 'package:din/common/widgets/common_button.dart';
import 'package:din/constants/gaps.dart';
import 'package:din/constants/sizes.dart';
import 'package:din/features/projects/edit_title_screen.dart';
import 'package:din/features/projects/view_models/goal_list_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GoalListTile extends ConsumerStatefulWidget {
  final bool? hasImage;
  final File? pickedImage;
  final String title;
  final int id;
  final int index;

  const GoalListTile({
    this.hasImage,
    this.pickedImage,
    required this.title,
    required this.id,
    required this.index,
    super.key,
  });

  @override
  ConsumerState<GoalListTile> createState() => _GoalCardState();
}

class _GoalCardState extends ConsumerState<GoalListTile> {
  @override
  Widget build(BuildContext context) {
    // final goals = ref.watch(goalListProvider);
    // final title = goals.firstWhere((goal) => goal.id == widget.id).title;
    // print("newTitle : $title");

    return GestureDetector(
      onTap: _showFloatingCard,
      child: Container(
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
              widget.hasImage == true
                  ? Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                        ),
                        image: DecorationImage(
                          image: FileImage(
                            widget.pickedImage!,
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
              // Gaps.h20,
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      color: Colors.grey.shade400,
                      width: 0.5,
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Sizes.size14,
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
            ],
          ),
        ),
      ),
    );
  }

  void _showFloatingCard() {
    final size = MediaQuery.of(context).size;

    showModalBottomSheet(
      backgroundColor: Colors.white,
      elevation: 0,
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Consumer(
          builder: (context, ref, child) {
            final goals = ref.watch(goalListProvider);
            final title =
                goals.firstWhere((goal) => goal.id == widget.id).title;

            return SafeArea(
              child: SizedBox(
                height: size.height * 0.75,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Gaps.v14,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: _onSettingPressed,
                            icon: const Icon(
                              Icons.settings,
                              size: 30,
                            ),
                          ),
                        ],
                      ),
                      Gaps.v10,
                      if (widget.pickedImage != null)
                        Container(
                          width: size.width * 0.87,
                          height: size.width * 0.87,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              width: 0.5,
                              color: Colors.grey.shade400,
                            ),
                            image: DecorationImage(
                              image: FileImage(
                                widget.pickedImage!,
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      if (widget.pickedImage == null)
                        Container(
                          width: size.width * 0.87,
                          height: size.width * 0.87,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              width: 0.5,
                              color: Colors.grey.shade400,
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.image_outlined,
                              size: 60,
                              color: Colors.grey.shade400,
                            ),
                          ),
                        ),
                      Gaps.v40,
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Spacer(),
                      CommonButton(
                        text: "Close",
                        bgColor: Colors.black,
                        color: Colors.white,
                        icon: Icons.arrow_back_ios_new_rounded,
                        onTap: () => Navigator.pop(context),
                      ),
                      Gaps.v12,
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
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
                  top: 28,
                  left: 20,
                  right: 20,
                ),
                child: Column(
                  children: [
                    const CommonButton(
                      text: 'Edit image',
                      icon: Icons.image_search_rounded,
                    ),
                    Gaps.v12,
                    CommonButton(
                      text: 'Edit title',
                      icon: Icons.build_outlined,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditTitleScreen(
                              title: widget.title,
                              id: widget.id,
                            ),
                          ),
                        );
                      },
                    ),
                    Gaps.v12,
                    CommonButton(
                      icon: Icons.remove_circle_outline_rounded,
                      text: 'Delete goal',
                      onTap: _onDeleteGoalTap,
                    ),
                    Gaps.v12,
                    CommonButton(
                      text: 'Cancel',
                      bgColor: Colors.black,
                      color: Colors.white,
                      icon: Icons.arrow_back_ios_new_rounded,
                      onTap: () => Navigator.pop(context),
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

  void _onDeleteGoalTap() {
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
                  left: Sizes.size20,
                  right: Sizes.size20,
                ),
                child: Column(
                  children: [
                    Gaps.v20,
                    const SizedBox(
                      height: 50,
                      child: Text(
                        "Are you sure you want to delete the goal?",
                        style: TextStyle(
                          fontSize: 17,
                        ),
                      ),
                    ),
                    Gaps.v20,
                    CommonButton(
                      icon: Icons.remove_circle_outline_rounded,
                      text: 'Yes',
                      onTap: () => ref
                          .read(goalListProvider.notifier)
                          .deleteGoal(context, widget.id),
                    ),
                    Gaps.v12,
                    CommonButton(
                      text: 'Cancel',
                      bgColor: Colors.black,
                      color: Colors.white,
                      icon: Icons.arrow_back_ios_new_rounded,
                      onTap: () => Navigator.pop(context),
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
