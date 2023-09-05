import 'dart:io';

import 'package:din/constants/sizes.dart';
import 'package:din/features/projects/edit_title_screen.dart';
import 'package:din/features/projects/list_of_goals_screen.dart';
import 'package:din/features/projects/models/goal_model.dart';
import 'package:din/features/projects/view_models/goal_list_view_model.dart';
import 'package:din/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class GoalListTile extends ConsumerStatefulWidget {
  final bool? hasImage;
  final File? pickedImage;
  final String title;
  final int id;
  final int index;
  final bool? isWrapUp;
  final List<GoalModel>? goalList;

  const GoalListTile({
    this.hasImage,
    this.pickedImage,
    required this.title,
    required this.id,
    required this.index,
    this.isWrapUp,
    this.goalList,
    super.key,
  });

  @override
  ConsumerState<GoalListTile> createState() => _GoalCardState();
}

class _GoalCardState extends ConsumerState<GoalListTile> {
  late List<Map<String, dynamic>> goalModalList;

  @override
  void initState() {
    super.initState();

    goalModalList = [
      {
        "text": "이미지 변경",
        "icon": Icons.image_search_rounded,
        "onTap": () => _onChangeImageTap(widget.id),
      },
      {
        "text": "제목 변경",
        "icon": Icons.build_outlined,
        "onTap": _onEditTitleTap,
      },
      {
        "text": "목표 삭제",
        "icon": Icons.remove_circle_outline_rounded,
        "onTap": () => showModalBottomWithText(
              context,
              "목표를 삭제하시겠습니까?",
              _onDeleteGoalTap,
            ),
      },
    ];
  }

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
      showErrorSnack(context, "이미지가 변경되었습니다");
    }
  }

  void _onEditTitleTap() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditTitleScreen(
          title: widget.title,
          id: widget.id,
          goalList: widget.goalList!,
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
            Expanded(
              child: Container(
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
            ),
            if (widget.isWrapUp != true)
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
