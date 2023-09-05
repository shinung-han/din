import 'package:din/common/widgets/common_button.dart';
import 'package:din/constants/gaps.dart';
import 'package:din/features/projects/view_models/date_view_model.dart';
import 'package:din/features/projects/view_models/goal_list_view_model.dart';
import 'package:din/features/projects/view_models/project_view_model.dart';
import 'package:din/features/projects/widgets/date_information.dart';
import 'package:din/features/projects/widgets/goal_list_tile.dart';
import 'package:din/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class WrapUpScreen extends ConsumerStatefulWidget {
  final bool isWrapUp;

  const WrapUpScreen({
    required this.isWrapUp,
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WrapUpScreenState();
}

class _WrapUpScreenState extends ConsumerState<WrapUpScreen> {
  void _onCreateProject(
    String userId,
    DateTime startDate,
    DateTime endDate,
    int period,
  ) {
    final goals = ref.watch(goalListProvider);

    ref
        .read(projectProvider.notifier)
        .addProject(userId, startDate, endDate, period, goals);

    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    final date = ref.watch(dateProvider);
    final goals = ref.watch(goalListProvider);
    final user = ref.watch(projectProvider);

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            const SliverAppBar(
              title: Text(
                '마무리',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Column(
                    children: [
                      header(),
                      Gaps.v10,
                      DateInformation(date: date),
                      Gaps.v14,
                      divider(),
                      Gaps.v14,
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: SingleChildScrollView(
                          child: Column(
                            children: goals.map((goal) {
                              final hasImage = goal.image != null;
                              final image = goal.image;
                              final title = goal.title;
                              final id = goal.id;

                              return Column(
                                children: [
                                  GoalListTile(
                                    hasImage: hasImage,
                                    pickedImage: image,
                                    title: title,
                                    id: id,
                                    index: 1,
                                    isWrapUp: widget.isWrapUp,
                                  ),
                                  Gaps.v8,
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 90,
        child: CommonButton(
          text: "프로젝트 생성",
          bgColor: Colors.black,
          color: Colors.white,
          onTap: () => _onCreateProject(
            user!.uid,
            date.startDate,
            date.endDate,
            date.period,
          ),
          icon: Icons.task_alt_rounded,
        ),
      ),
    );
  }

  Widget header() {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: const Column(
        children: [
          Text(
            "준비됐나요?",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
          Gaps.v10,
          Text(
            "지금까지의 준비를 살펴보며 자신감을 얻어봅시다.\n시작이 좋으면 결과도 좋습니다!\n준비가 되었다면 이제 시작해 봅시다!",
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
