import 'package:din/common/widgets/main_navigation_screen.dart';
import 'package:din/constants/gaps.dart';
import 'package:din/constants/sizes.dart';
import 'package:din/features/projects/edit_db_title_screen.dart';
import 'package:din/features/projects/view_models/db_goal_list_view_model.dart';
import 'package:din/features/projects/view_models/project_view_model.dart';
import 'package:din/utils.dart';
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

    Navigator.popUntil(
        context, ModalRoute.withName(MainNavigationScreen.routeName));
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(projectProvider);
    final goalsList = ref.watch(dbGoalListProvider);
    // print(goalsList);
    // print("user : ${user!.uid}");

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
            onTap: () => showModalBottomWithText(
              context,
              "Are you sure you want to delete the project?",
              () => _onDeleteProject(user),
            ),
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
      body: Padding(
        padding: const EdgeInsets.only(
          left: 10,
          right: 10,
          top: 10,
        ),
        child: ListView.builder(
          itemCount: goalsList.length,
          itemBuilder: (context, index) {
            final image = goalsList[index].image;
            final title = goalsList[index].title;

            return Column(
              children: [
                GoalListTile(
                  title: title,
                  image: image ?? '',
                ),
                Gaps.v8,
              ],
            );
          },
        ),
      ),
    );
  }
}

class GoalListTile extends StatelessWidget {
  final String title;
  final String image;

  const GoalListTile({
    super.key,
    required this.title,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> goalModalList = [
      {
        "text": "Edit image",
        "icon": Icons.image_search_rounded,
        "onTap": () {}
      },
      {
        "text": "Edit title",
        "icon": Icons.build_outlined,
        "onTap": (context) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const EditDbTitleScreen(),
              settings: RouteSettings(arguments: {"title": title}),
            ),
          );
        }
      },
    ];

    return Container(
      decoration: BoxDecoration(
          border: Border.all(
            width: 0.5,
            color: Colors.grey.shade400,
          ),
          borderRadius: BorderRadius.circular(10)),
      child: SizedBox(
        height: 80,
        child: Row(
          children: [
            image != ""
                ? Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                      ),
                      image: DecorationImage(
                        image: NetworkImage(
                          image,
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                : SizedBox(
                    width: 80,
                    height: 80,
                    child: Center(
                      child: Icon(
                        Icons.image_outlined,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: Sizes.size14,
                ),
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      color: Colors.grey.shade400,
                      width: 0.5,
                    ),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                onPressed: () => showModalBottom(context, goalModalList),
                icon: const Icon(Icons.more_vert_rounded),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
