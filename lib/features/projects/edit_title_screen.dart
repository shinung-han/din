import 'package:din/common/widgets/common_appbar.dart';
import 'package:din/common/widgets/submit_button.dart';
import 'package:din/constants/sizes.dart';
import 'package:din/features/projects/view_models/goal_list_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EditTitleScreen extends ConsumerStatefulWidget {
  final String title;
  final int id;

  const EditTitleScreen({
    required this.title,
    required this.id,
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
    setState(() {
      isButtonEnabled = _titleController.text.length > 2;
    });
  }

  void _onDeleteTap(controller) {
    setState(() {
      _titleController.clear();
    });
  }

  void _onSubmit() {
    ref.read(goalListProvider.notifier).changeGoalTitle(
          widget.id,
          _titleController.text,
        );
    Navigator.pop(context);
    Navigator.pop(context);
    // Navigator.popUntil(
    //     context, ModalRoute.withName(ListOfGoalsScreen.routeName));
  }

  bool isButtonEnabled = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onScaffoldTap,
      child: Scaffold(
        appBar: const CommonAppBar(title: "Modify title"),
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
                    onFieldSubmitted: (_) => _onSubmit(),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    maxLength: 20,
                    decoration: InputDecoration(
                      labelStyle: TextStyle(color: Colors.grey.shade400),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade400)),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade400),
                      ),
                      labelText: "New title",
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
            onTap: _onSubmit,
            buttonText: 'Edit',
          ),
        ),
      ),
    );
  }
}
