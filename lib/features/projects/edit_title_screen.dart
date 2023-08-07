import 'package:din/common/widgets/common_appbar.dart';
import 'package:din/common/widgets/submit_button.dart';
import 'package:din/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EditTitleScreen extends StatefulWidget {
  final String title;

  const EditTitleScreen({
    required this.title,
    super.key,
  });

  @override
  State<EditTitleScreen> createState() => _ModifyTitleScreenState();
}

class _ModifyTitleScreenState extends State<EditTitleScreen> {
  void _onScaffoldTap() {
    FocusScope.of(context).unfocus();
  }

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late final TextEditingController _titleController =
      TextEditingController(text: widget.title)
        ..addListener(() {
          updateButtonState();
          setState(() {
            _newTitle = _titleController.text;
          });
        });

  String _newTitle = '';

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
    // ref.read(changePasswordProvider.notifier).passwordUpdate(
    //       context,
    //       _newPassword,
    //     );
    Navigator.pop(context, _newTitle);
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
