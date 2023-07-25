import 'package:din/features/authentication/list_setting_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../common/widgets/common_button.dart';

class ListOfGoalsScreen extends StatefulWidget {
  const ListOfGoalsScreen({super.key});

  @override
  State<ListOfGoalsScreen> createState() => _ListOfGoalsScreenState();
}

class _ListOfGoalsScreenState extends State<ListOfGoalsScreen> {
  final List<String> _titles = [];

  void _onGoalSettingTap() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ListSettingScreen(),
      ),
    );
    print(result);
    if (result == null) return;

    setState(() {
      _titles.add(result);
    });
  }

  void _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.only(
            top: 20,
            right: 10,
            left: 10,
            bottom: 30,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ListTile(
                leading: const Icon(Icons.videocam),
                title: const Text('Modify'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.share),
                title: const Text('Cancel'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Create Project',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: _onGoalSettingTap,
              child: const FaIcon(
                FontAwesomeIcons.plus,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: ListView.builder(
          itemCount: _titles.length,
          itemBuilder: (context, index) {
            return Card(
              color: Colors.white,
              elevation: 0.1,
              child: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                leading: CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage(
                    'assets/images/${index + 1}.jpg',
                  ),
                  // child: Text('Hello'),
                ),
                /* leading: const Icon(
                  Icons.account_circle_rounded,
                  size: 40,
                ), */
                title: Text(_titles[index]),
                subtitle: const Text('This is subtitle'),
                trailing: GestureDetector(
                  onTap: _showBottomSheet,
                  child: const FaIcon(FontAwesomeIcons.ellipsis),
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: CommonButton(
          text: 'Next',
          bgColor: Colors.black,
          color: Colors.white,
          onTap: () {},
        ),
      ),
    );
  }
}
