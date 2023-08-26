import 'package:din/constants/gaps.dart';
import 'package:din/features/projects/add_goal_screen.dart';
import 'package:din/features/projects/view_models/goal_list_view_model.dart';
import 'package:din/features/projects/widgets/goal_list_tile.dart';
import 'package:din/features/projects/wrap_up_screen.dart';
import 'package:din/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/widgets/common_button.dart';

class ListOfGoalsScreen extends ConsumerStatefulWidget {
  static String routeURL = 'goal_list';
  static String routeName = 'goal_list';

  const ListOfGoalsScreen({super.key});

  @override
  ConsumerState<ListOfGoalsScreen> createState() => _ListOfGoalsScreenState();
}

class _ListOfGoalsScreenState extends ConsumerState<ListOfGoalsScreen> {
  void _onAddGoalTap(goals) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddGoalScreen(
          goalList: goals,
        ),
      ),
    );
  }

  void _onSubmit(goals) {
    if (goals.isEmpty) {
      showErrorSnack(context, "Please create goals");
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const WrapUpScreen(
            isWrapUp: true,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isEmpty = ref.watch(goalListProvider).isEmpty;
    final goals = ref.watch(goalListProvider);

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              title: const Align(
                alignment: Alignment.center,
                child: Text(
                  'Create Project',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              actions: [
                if (goals.isNotEmpty)
                  GestureDetector(
                    onTap: () => showModalBottomWithText(
                      context,
                      "Are you sure you want to delete all goals?",
                      () {
                        ref
                            .read(goalListProvider.notifier)
                            .deleteAllGoals(context);
                      },
                    ),
                    child: const Icon(
                      Icons.remove_circle_outline_rounded,
                      size: 30,
                    ),
                  ),
                GestureDetector(
                  onTap: () => _onAddGoalTap(goals),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Icon(
                      Icons.add_circle_outline_rounded,
                      size: 30,
                    ),
                  ),
                ),
              ],
            ),
            isEmpty
                ? SliverPadding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    sliver: SliverFillRemaining(
                      hasScrollBody: false, // 스크롤이 발생하지 않도록 설정
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.north_east_rounded,
                                size: 50,
                              ),
                              Icon(
                                Icons.add_circle_outline_rounded,
                                size: 50,
                              ),
                            ],
                          ),
                          Gaps.v16,
                          Text("Tap the icon in the top right to add a goal"),
                        ],
                      ),
                    ),
                  )
                : SliverPadding(
                    padding: const EdgeInsets.only(
                      left: 10,
                      right: 10,
                      top: 10,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final hasImage = goals[index].image != null;
                          final image = goals[index].image;
                          final title = goals[index].title;
                          final id = goals[index].id;

                          return Column(
                            children: [
                              GoalListTile(
                                hasImage: hasImage,
                                pickedImage: image,
                                title: title,
                                id: id,
                                index: index,
                                goalList: goals,
                              ),
                              Gaps.v8,
                            ],
                          );
                        },
                        childCount: goals.length,
                      ),
                    ),
                  ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 128,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.warning_amber_rounded),
                Gaps.h5,
                Text("After creating a project, you can't add or delete goals"),
              ],
            ),
            Gaps.v10,
            Container(
              height: 66,
              child: CommonButton(
                text: 'Next',
                bgColor: Colors.black,
                color: Colors.white,
                onTap: () => _onSubmit(goals),
                icon: Icons.arrow_forward_ios_rounded,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
