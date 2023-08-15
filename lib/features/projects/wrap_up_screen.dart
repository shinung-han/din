import 'package:din/common/widgets/common_button.dart';
import 'package:din/constants/gaps.dart';
import 'package:din/constants/sizes.dart';
import 'package:din/features/projects/models/date_model.dart';
import 'package:din/features/projects/view_models/date_view_model.dart';
import 'package:din/features/projects/view_models/goal_list_view_model.dart';
import 'package:din/features/projects/view_models/project_view_model.dart';
import 'package:din/features/projects/widgets/goal_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

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
                'Wrap up',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(Sizes.size20),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Column(
                      children: [
                        header(),
                        title('Date information', 200),
                        dateInformation(date),
                        title('Goal list', 120),
                        SingleChildScrollView(
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
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 90,
        child: CommonButton(
          text: "Done",
          bgColor: Colors.black,
          color: Colors.white,
          onTap: () => _onCreateProject(
            user!.uid,
            date.startDate,
            date.endDate,
            date.period + 1,
          ),
          icon: Icons.task_alt_rounded,
        ),
      ),
    );
  }

  Widget header() {
    return const Column(
      children: [
        Text(
          "Are you ready?",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        Text(
          "Create your own fantastic project to become a better version of yourself than yesterday.",
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget title(String title, double width) {
    return Column(
      children: [
        Gaps.v40,
        Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Divider(
                color: Colors.grey.shade400,
                indent: 10,
                endIndent: 10,
                thickness: 0.5,
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                width: width,
                color: Colors.white,
                alignment: Alignment.center,
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
        Gaps.v16,
      ],
    );
  }

  IntrinsicHeight dateInformation(DateModel date) {
    const textStyle = TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w500,
    );

    return IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              const Text(
                'Start date',
                style: textStyle,
              ),
              Gaps.v4,
              Text(DateFormat.yMd().format(date.startDate)),
            ],
          ),
          verticalDivider(),
          Column(
            children: [
              const Text(
                'End date',
                style: textStyle,
              ),
              Gaps.v4,
              Text(DateFormat.yMd().format(date.endDate)),
            ],
          ),
          verticalDivider(),
          Column(
            children: [
              const Text(
                'Period',
                style: textStyle,
              ),
              Gaps.v4,
              Text('For ${date.period + 1} days'),
            ],
          ),
        ],
      ),
    );
  }

  VerticalDivider verticalDivider() {
    return VerticalDivider(
      width: Sizes.size1,
      indent: Sizes.size8,
      endIndent: Sizes.size8,
      color: Colors.grey.shade400,
      thickness: 0.5,
    );
  }
}
