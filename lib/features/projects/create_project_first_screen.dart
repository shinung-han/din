import 'package:din/features/projects/set_date_screen.dart';
import 'package:din/common/widgets/common_button.dart';
import 'package:din/constants/gaps.dart';
import 'package:din/features/authentication/widgets/auth_header.dart';
import 'package:din/features/projects/view_models/project_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CreateProjectFirstScreen extends ConsumerStatefulWidget {
  const CreateProjectFirstScreen({super.key});

  @override
  ConsumerState<CreateProjectFirstScreen> createState() =>
      _ProjectScreenState();
}

class _ProjectScreenState extends ConsumerState<CreateProjectFirstScreen> {
  void _onCreateProject() {
    context.go('/home/${SetDateScreen.routeURL}');
  }

  void _onViewTutorial(user) {
    // print(user.hasProject);
    // TODO 나중에 지워야함
    ref.read(projectProvider.notifier).updateHasProject(!user.hasProject);
  }

  @override
  void initState() {
    super.initState();
    ref.read(projectProvider.notifier).loadUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(projectProvider);
    print("view : ${user!.hasProject}");

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Gaps.v48,
                const AuthHeader(
                  title: 'There is no Project',
                  subTitle:
                      'Create your own fantastic project to become a better version of yourself than yesterday.',
                ),
                Gaps.v20,
                CommonButton(
                  text: 'Create a Project',
                  bgColor: Colors.black,
                  color: Colors.white,
                  icon: Icons.add_location_alt_outlined,
                  onTap: _onCreateProject,
                ),
                Gaps.v16,
                CommonButton(
                  text: 'View Tutorial',
                  onTap: () => _onViewTutorial(user),
                  icon: Icons.navigation_outlined,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
