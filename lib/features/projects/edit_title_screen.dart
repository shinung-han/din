import 'package:din/common/widgets/common_appbar.dart';
import 'package:din/common/widgets/submit_button.dart';
import 'package:din/constants/sizes.dart';
import 'package:din/features/projects/models/goal_model.dart';
import 'package:din/features/projects/view_models/goal_list_view_model.dart';
import 'package:din/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EditTitleScreen extends ConsumerStatefulWidget {
  final String? title;
  final int? id;
  final List<GoalModel> goalList;

  const EditTitleScreen({
    this.title,
    this.id,
    required this.goalList,
    super.key,
  });

  @override
  ConsumerState<EditTitleScreen> createState() => _ModifyTitleScreenState();
}

class _ModifyTitleScreenState extends ConsumerState<EditTitleScreen> {
  void _onScaffoldTap() {
    FocusScope.of(context).unfocus();
  }

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late final TextEditingController _titleController =
      TextEditingController(text: widget.title)
        ..addListener(() {
          updateButtonState();
        });

  void updateButtonState() {
    if (widget.title == _titleController.text ||
        _titleController.text.isEmpty) {
      setState(() {
        isButtonEnabled = false;
      });
    } else {
      setState(() {
        isButtonEnabled = true;
      });
    }
  }

  void _onDeleteTap(controller) {
    setState(() {
      _titleController.clear();
    });
  }

  void _onSubmit(goalList) {
    bool isDuplicate = false;

    for (var goal in goalList) {
      if (goal.title.contains(_titleController.text)) {
        isDuplicate = true;
        break;
      }
    }

    if (isDuplicate) {
      showErrorSnack(context, "동일한 제목이 존재합니다");
      return;
    }

    ref.read(goalListProvider.notifier).changeGoalTitle(
          widget.id!,
          _titleController.text,
        );
    Navigator.pop(context);
    Navigator.pop(context);
    showErrorSnack(context, "제목이 변경되었습니다");
  }

  bool isButtonEnabled = false;

  @override
  Widget build(BuildContext context) {
    print(widget.title);
    print(widget.goalList[0].title);

    return GestureDetector(
      onTap: _onScaffoldTap,
      child: Scaffold(
        appBar: const CommonAppBar(title: "제목 변경"),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(Sizes.size20),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _titleController,
                    cursorHeight: Sizes.size16,
                    autocorrect: false,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    maxLength: 20,
                    decoration: InputDecoration(
                      labelStyle: TextStyle(color: Colors.grey.shade400),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade400)),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade400),
                      ),
                      labelText: "새로운 제목",
                      suffix: Padding(
                        padding: const EdgeInsets.only(right: Sizes.size10),
                        child: GestureDetector(
                          onTap: () => _onDeleteTap(_titleController),
                          child: FaIcon(
                            FontAwesomeIcons.xmark,
                            size: Sizes.size18,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          height: 90,
          child: SubmitButton(
            disabled: isButtonEnabled,
            onTap: () => _onSubmit(widget.goalList),
            buttonText: '변경',
            icon: Icons.edit_outlined,
          ),
        ),
      ),
    );
  }
}
