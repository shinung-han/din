import 'package:din/features/projects/set_date_screen.dart';
import 'package:din/common/widgets/common_button.dart';
import 'package:din/constants/gaps.dart';
import 'package:din/features/authentication/widgets/auth_header.dart';
import 'package:din/features/onboarding/tutorial_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CreateProjectFirstScreen extends StatefulWidget {
  const CreateProjectFirstScreen({super.key});

  @override
  State<CreateProjectFirstScreen> createState() => _ProjectScreenState();
}

class _ProjectScreenState extends State<CreateProjectFirstScreen> {
  void _onCreateProject() {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => const SetDateScreen(),
    //   ),
    // );
    context.go('/home/${SetDateScreen.routeURL}');
  }

  void _onViewTutorial() {
    context.go(TutorialScreen.routeURL);
  }

  @override
  Widget build(BuildContext context) {
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
                  onTap: _onViewTutorial,
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
