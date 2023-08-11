import 'package:din/common/widgets/common_button.dart';
import 'package:din/constants/gaps.dart';
import 'package:din/constants/sizes.dart';
import 'package:din/features/projects/view_models/project_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditProjectScreen extends ConsumerStatefulWidget {
  const EditProjectScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditProjectScreenState();
}

class _EditProjectScreenState extends ConsumerState<EditProjectScreen> {
  void _onDeleteProject(user) {
    ref.read(projectProvider.notifier).updateHasProject(!user.hasProject);
    ref.read(projectProvider.notifier).deleteProject(user.uid);
    Navigator.pop(context);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Align(
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.only(left: Sizes.size24),
            child: Text(
              'Edit Project',
              style: TextStyle(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        actions: [
          GestureDetector(
            onTap: _onDeleteProjectTap,
            child: const Icon(
              Icons.remove_circle_outline_rounded,
              size: 30,
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Icon(
                Icons.edit_calendar_outlined,
                size: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onDeleteProjectTap() {
    final user = ref.watch(projectProvider);

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
                  left: Sizes.size16,
                  right: Sizes.size16,
                ),
                child: Column(
                  children: [
                    Gaps.v20,
                    const SizedBox(
                      height: 50,
                      child: Text(
                        "Are you sure you want to delete the project?",
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
                        onTap: () => _onDeleteProject(user),
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
