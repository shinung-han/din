import 'package:din/common/widgets/common_appbar.dart';
import 'package:din/common/widgets/submit_button.dart';
import 'package:din/constants/gaps.dart';
import 'package:din/constants/sizes.dart';
import 'package:din/features/projects/view_models/db_goal_list_view_model.dart';
import 'package:din/features/projects/view_models/db_title_project_view_model.dart';
import 'package:din/features/projects/view_models/project_view_model.dart';
import 'package:din/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EditDbTitleScreen extends ConsumerStatefulWidget {
  const EditDbTitleScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditDbTitleScreenState();
}

class _EditDbTitleScreenState extends ConsumerState<EditDbTitleScreen> {
  void _onScaffoldTap() {
    FocusScope.of(context).unfocus();
  }

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late final TextEditingController _titleController = TextEditingController()
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

  void _onSubmit(String userId, String oldTitle) {
    ref
        .read(editTitleProvider.notifier)
        .editTitle(userId, oldTitle, _titleController.text);
    ref
        .read(dbGoalListProvider.notifier)
        .updateTitle(oldTitle, _titleController.text);
    showErrorSnack(context, "The title has been changed");
  }

  bool isButtonEnabled = false;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(projectProvider);
    final arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;

    return GestureDetector(
      onTap: _onScaffoldTap,
      child: Scaffold(
        appBar: const CommonAppBar(title: "Edit title"),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(Sizes.size20),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _titleController,
                    cursorHeight: Sizes.size16,
                    autocorrect: false,
                    // onFieldSubmitted: (_) =>
                    //     _onSubmit(user.uid, arguments["title"]!),
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
                      counterText: '',
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
                  Gaps.v10,
                  Padding(
                    padding: const EdgeInsets.only(left: Sizes.size2),
                    child: Text(
                      'Titles can be changed once every 3 days.',
                      style: TextStyle(
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                  Gaps.v4,
                  Padding(
                    padding: const EdgeInsets.only(left: Sizes.size2),
                    child: Text(
                      "Title up to 20 characters",
                      style: TextStyle(
                        color: Colors.grey.shade700,
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
            onTap: () => _onSubmit(user!.uid, arguments["title"]!),
            buttonText: 'Edit',
            icon: Icons.edit_outlined,
          ),
        ),
      ),
    );
  }
}
