import 'package:din/constants/sizes.dart';
import 'package:din/features/calendar/view_models/calendar_view_model.dart';
import 'package:din/features/projects/view_models/db_goal_list_view_model.dart';
import 'package:din/features/projects/view_models/memo_view_model.dart';
import 'package:din/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MemoScreen extends ConsumerStatefulWidget {
  final String userId;
  final String title;
  final String? memo;

  const MemoScreen({
    required this.userId,
    required this.title,
    this.memo,
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MemoScreenState();
}

class _MemoScreenState extends ConsumerState<MemoScreen> {
  final FocusNode _focusNode = FocusNode();

  late TextEditingController textController =
      textController = TextEditingController(text: widget.memo ?? "")
        ..addListener(() {
          setState(() {
            _isChanged = textController.text != widget.memo;
          });
        });

  bool _isChanged = false;

  void _onSubmitMemo() {
    ref.read(memoProvider.notifier).writeMemo(
          widget.userId,
          widget.title,
          textController.text,
        );
    ref
        .read(dbGoalListProvider.notifier)
        .updateMemo(widget.title, textController.text);

    final calendarViewModel = ref.read(calendarProvider.notifier);
    calendarViewModel.updateEventMemoOrRating(
      DateTime.now(),
      widget.title,
      textController.text,
      null,
    );

    showErrorSnack(context, "메모가 저장되었습니다");
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(_focusNode);
      },
      onPanDown: (details) {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: Sizes.size5),
              child: IconButton(
                onPressed: _isChanged ? _onSubmitMemo : null,
                icon: const Icon(
                  Icons.edit_outlined,
                  size: 30,
                ),
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Sizes.size20),
          child: TextField(
            focusNode: _focusNode,
            controller: textController,
            keyboardType: TextInputType.multiline,
            autocorrect: false,
            maxLines: null,
            onChanged: (text) {
              setState(() {});
            },
            decoration: InputDecoration(
              hintText: "탭 하여 메모를 작성해 보세요",
              hintStyle: TextStyle(
                color: Colors.grey.shade400,
                fontWeight: FontWeight.normal,
              ),
              border: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }
}
