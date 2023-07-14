import 'package:din/add_project_screen.dart';
import 'package:din/common/widgets/common_button.dart';
import 'package:din/constants/gaps.dart';
import 'package:din/features/authentication/widgets/auth_header.dart';
import 'package:din/features/onboarding/tutorial_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProjectScreen extends StatefulWidget {
  const ProjectScreen({super.key});

  @override
  State<ProjectScreen> createState() => _ProjectScreenState();
}

class _ProjectScreenState extends State<ProjectScreen> {
  void _onCreateProject() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddProjectScreen(),
      ),
    );
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
                Gaps.v40,
                const AuthHeader(
                  title: 'There is no Project',
                  subTitle:
                      'Create your own fantastic project to become a better version of yourself than yesterday.',
                ),
                Gaps.v80,
                CommonButton(
                  text: 'Create a Project',
                  bgColor: Colors.black,
                  color: Colors.white,
                  // icon: FontAwesomeIcons.list,
                  onTap: _onCreateProject,
                ),
                Gaps.v10,
                CommonButton(
                  text: 'View Tutorial',
                  onTap: _onViewTutorial,
                  // icon: FontAwesomeIcons.star,
                ),
              ],
            ),
          ),
        ),
      ),
    );

    /* return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              // width: 130,
              // height: 130,
              decoration: BoxDecoration(
                border: Border.all(
                  width: 5,
                  color: Colors.grey,
                ),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: GestureDetector(
                  onTap: _onAddProjectTap,
                  child: const FaIcon(
                    FontAwesomeIcons.plus,
                    size: 60,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            Gaps.v16,
            const Text(
              'Make your Project',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    ); */
  }
}
