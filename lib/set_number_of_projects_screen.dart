import 'package:din/cards_screen.dart';
import 'package:din/common/widgets/common_button.dart';
import 'package:din/constants/gaps.dart';
import 'package:din/features/authentication/widgets/auth_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SetNumberOfProjects extends StatefulWidget {
  const SetNumberOfProjects({super.key});

  @override
  State<SetNumberOfProjects> createState() => _SetNumberOfProjectsState();
}

class _SetNumberOfProjectsState extends State<SetNumberOfProjects> {
  void _onScaffoldTap() {
    FocusScope.of(context).unfocus();
  }

  int _numberOfProjects = 0;

  void _onSetNumberOfProjects(String value) {
    setState(() {
      _numberOfProjects = int.parse(value);
    });
  }

  void _onNextTap() {
    print(_numberOfProjects);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CardsScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onScaffoldTap,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Create Project',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          child: Column(
            children: [
              const AuthHeader(
                title: 'Number of projects',
                subTitle:
                    'Please enter the number of projects you want to complete per day.',
              ),
              Gaps.v20,
              TextField(
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  labelText: 'Enter a number',
                ),
                onChanged: (value) {
                  _onSetNumberOfProjects(value);
                },
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          child: CommonButton(
            text: 'Next',
            bgColor: Colors.black,
            color: Colors.white,
            onTap: _onNextTap,
          ),
        ),
      ),
    );
  }
}
