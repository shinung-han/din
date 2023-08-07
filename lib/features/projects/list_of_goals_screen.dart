import 'package:din/common/widgets/common_appbar.dart';
import 'package:din/constants/gaps.dart';
import 'package:din/features/authentication/widgets/auth_header.dart';
import 'package:din/features/projects/add_goal_screen.dart';
import 'package:din/features/projects/goal_detail_screen.dart';
import 'package:din/features/projects/widgets/goal_list_tile.dart';
import 'package:din/features/projects/wrap_up_screen.dart';
import 'package:din/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/widgets/common_button.dart';

class ListOfGoalsScreen extends ConsumerStatefulWidget {
  const ListOfGoalsScreen({super.key});

  @override
  ConsumerState<ListOfGoalsScreen> createState() => _ListOfGoalsScreenState();
}

class _ListOfGoalsScreenState extends ConsumerState<ListOfGoalsScreen> {
  final GlobalKey<AnimatedListState> _key = GlobalKey<AnimatedListState>();

  final List<Map<String, dynamic>> _goalList = [];

  void _onAddGoalTap() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddGoalScreen(),
      ),
    );
    if (result == null) return;
    setState(() {
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
        child: GoalListTile(title: title, id: id, index: index),
      ),
      duration: _duration,
    );
    _goalList.removeAt(index);
    Navigator.pop(context);
    // print("index, title, id");
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
      showErrorSnack(context, "Please create goals");
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const WrapUpScreen(),
        ),
      );
    }
  }

  void _onGoalDetailTap() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const GoalDetailScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isEmpty = _goalList.isEmpty;

    return Scaffold(
      appBar: CommonAppBar(
        title: 'Create Project',
        icon: Icons.add_circle_outline_rounded,
        onPressed: _onAddGoalTap,
      ),
      body: isEmpty
          ? Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              child: Column(
                children: [
                  const AuthHeader(
                    title: 'Create goals',
                    subTitle:
                        'Create your own fantastic project to become a better version of yourself than yesterday.',
                  ),
                  Gaps.v20,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.north_east_rounded,
                        color: Colors.grey.shade400,
                        size: 50,
                      ),
                      Icon(
                        Icons.add_circle_outline_rounded,
                        color: Colors.grey.shade400,
                        size: 50,
                      ),
                    ],
                  ),
                  Gaps.v10,
                  Text(
                    "Tap the icon in the top right to add a goal",
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.only(
                left: 10,
                right: 10,
                top: 10,
              ),
              child: AnimatedList(
                key: _key,
                initialItemCount: _goalList.length,
                itemBuilder: (context, index, animation) {
                  final hasImage = _goalList[index]["hasImage"];
                  final image = _goalList[index]['image'];
                  final title = _goalList[index]['title'];
                  // final id = _goalList[index]['id'];

                  return FadeTransition(
                    key: UniqueKey(),
                    opacity: animation,
                    child: SizeTransition(
                      sizeFactor: animation,
                      child: Column(
                        children: [
                          GoalListTile(
                            hasImage: hasImage,
                            pickedImage: image,
                            title: title,
                            // id: id,
                            index: index,
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
          icon: Icons.arrow_forward_ios_rounded,
        ),
      ),
    );
  }

  // Card _makeCard(int index, String title, String id) {
  //   return Card(
  //     color: Colors.white,
  //     elevation: 0.1,
  //     child: ListTile(
  //       contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  //       leading: CircleAvatar(
  //         radius: 30,
  //         backgroundImage: AssetImage(
  //           'assets/images/${index + 1}.jpg',
  //         ),
  //         // child: Text('Hello'),
  //       ),
  //       /* leading: const Icon(
  //               Icons.account_circle_rounded,
  //               size: 40,
  //             ), */
  //       title: Text(title),
  //       subtitle: Text(id),
  //       trailing: GestureDetector(
  //         onTap: () => _showBottomSheet(index, title, id),
  //         child: const FaIcon(FontAwesomeIcons.ellipsis),
  //       ),
  //     ),
  //   );
  // }
}
