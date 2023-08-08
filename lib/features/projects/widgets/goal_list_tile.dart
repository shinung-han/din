import 'dart:io';

import 'package:din/common/widgets/common_button.dart';
import 'package:din/constants/gaps.dart';
import 'package:din/constants/sizes.dart';
import 'package:din/features/projects/edit_title_screen.dart';
import 'package:din/features/projects/list_of_goals_screen.dart';
import 'package:din/features/projects/models/goal_model.dart';
import 'package:din/features/projects/view_models/goal_list_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

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
  Future<void> _onChangeImageTap(int goalId) async {
    final ImagePicker imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      final File imageFile = File(pickedFile.path);
      ref.read(goalListProvider.notifier).updateGoalImage(goalId, imageFile);

      if (!mounted) return;
      Navigator.pop(context);
    }
  }

  void _onEditTitleTap() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditTitleScreen(
          title: widget.title,
          id: widget.id,
        ),
      ),
    );
  }

  void _onDeleteGoalTap() {
    ref.read(goalListProvider.notifier).deleteGoal(widget.id);
    Navigator.popUntil(
      context,
      ModalRoute.withName(ListOfGoalsScreen.routeURL),
    );
  }

  @override
  Widget build(BuildContext context) {
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
            final title = goals
                .firstWhere((goal) => goal.id == widget.id,
                    orElse: () =>
                        GoalModel(id: -1, title: 'Default Title', image: null))
                .title;

            return SafeArea(
              child: SizedBox(
                height: size.height * 0.75,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Sizes.size16),
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
                      SizedBox(
                        height: 66,
                        child: CommonButton(
                          text: "Close",
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
            );
          },
        );
      },
    );
  }

  void _onSettingPressed() {
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
                  top: Sizes.size32,
                  left: Sizes.size16,
                  right: Sizes.size16,
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 66,
                      child: CommonButton(
                        text: 'Edit image',
                        icon: Icons.image_search_rounded,
                        onTap: () => _onChangeImageTap(widget.id),
                      ),
                    ),
                    Gaps.v16,
                    SizedBox(
                      height: 66,
                      child: CommonButton(
                        text: 'Edit title',
                        icon: Icons.build_outlined,
                        onTap: _onEditTitleTap,
                      ),
                    ),
                    Gaps.v16,
                    SizedBox(
                      height: 66,
                      child: CommonButton(
                        icon: Icons.remove_circle_outline_rounded,
                        text: 'Delete goal',
                        onTap: _showFloatingDeleteModal,
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

  void _showFloatingDeleteModal() {
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
                    SizedBox(
                      height: 66,
                      child: CommonButton(
                        icon: Icons.remove_circle_outline_rounded,
                        text: 'Yes',
                        onTap: _onDeleteGoalTap,
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
