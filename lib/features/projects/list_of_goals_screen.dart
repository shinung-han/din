import 'package:din/constants/gaps.dart';
import 'package:din/features/projects/add_goal_screen.dart';
import 'package:din/features/projects/widgets/goal_card.dart';
import 'package:din/utils.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../common/widgets/common_button.dart';

class ListOfGoalsScreen extends StatefulWidget {
  const ListOfGoalsScreen({super.key});

  @override
  State<ListOfGoalsScreen> createState() => _ListOfGoalsScreenState();
}

class _ListOfGoalsScreenState extends State<ListOfGoalsScreen> {
  final GlobalKey<AnimatedListState> _key = GlobalKey<AnimatedListState>();

  final List<Map<String, dynamic>> _goalList = [];

  void _onAddGoalTap() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddGoalScreen(),
      ),
    );
    print(result);
    if (result == null) return;

    setState(() {
      // _goalList.add(result);
      _addGoal(result);
    });
  }

  final Duration _duration = const Duration(milliseconds: 300);

  void _addGoal(result) {
    _goalList.add(result);
    if (_key.currentState != null) {
      _key.currentState!.insertItem(
        _goalList.length - 1,
        duration: _duration,
      );
    }
  }

  void _deleteGoal(int index, String title, String id) {
    _key.currentState!.removeItem(
      index,
      (context, animation) => SizeTransition(
        sizeFactor: animation,
        child: GoalCard(title: title, id: id, index: index),
      ),
      duration: _duration,
    );
    _goalList.removeAt(index);
    Navigator.pop(context);
  }

  void _showBottomSheet(int index, String title, String id) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Container(
            height: 230,
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                CommonButton(
                  text: 'Delete',
                  bgColor: Colors.black,
                  color: Colors.white,
                  onTap: () => _deleteGoal(index, title, id),
                ),
                Gaps.v16,
                CommonButton(
                  text: 'Cancel',
                  onTap: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _onSubmit() {
    if (_goalList.isEmpty) {
      showErrorSnack(context, "Please create a target.");
    }
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
              onTap: _onAddGoalTap,
              child: const FaIcon(
                FontAwesomeIcons.plus,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: AnimatedList(
          key: _key,
          initialItemCount: _goalList.length,
          itemBuilder: (context, index, animation) {
            final title = '${_goalList[index]['title']}';
            final id = '${_goalList[index]['id']}';

            return FadeTransition(
              key: UniqueKey(),
              opacity: animation,
              child: SizeTransition(
                sizeFactor: animation,
                child: Column(
                  children: [
                    GoalCard(
                      title: title,
                      id: id,
                      index: index,
                      onTap: (index, title, id) =>
                          _showBottomSheet(index, title, id),
                    ),
                    Gaps.v8,
                  ],
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 90,
        child: CommonButton(
          text: 'Next',
          bgColor: Colors.black,
          color: Colors.white,
          onTap: _onSubmit,
        ),
      ),
    );
  }

  Card _makeCard(int index, String title, String id) {
    return Card(
      color: Colors.white,
      elevation: 0.1,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
        title: Text(title),
        subtitle: Text(id),
        trailing: GestureDetector(
          onTap: () => _showBottomSheet(index, title, id),
          child: const FaIcon(FontAwesomeIcons.ellipsis),
        ),
      ),
    );
  }
}
