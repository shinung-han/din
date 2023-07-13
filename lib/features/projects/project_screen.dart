import 'package:din/add_project_screen.dart';
import 'package:din/constants/gaps.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProjectScreen extends StatefulWidget {
  const ProjectScreen({super.key});

  @override
  State<ProjectScreen> createState() => _ProjectScreenState();
}

class _ProjectScreenState extends State<ProjectScreen> {
  void _onAddProjectTap() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddProjectScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
    );
  }
}
