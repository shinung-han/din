import 'package:din/constants/gaps.dart';
import 'package:din/constants/sizes.dart';
import 'package:din/features/chart/view_model/chart_view_model.dart';
import 'package:din/features/chart/widgets/bar_chart.dart';
import 'package:din/features/projects/models/db_goal_model.dart';
import 'package:din/features/projects/view_models/db_goal_list_view_model.dart';
import 'package:din/features/projects/view_models/project_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ChartScreen extends ConsumerStatefulWidget {
  const ChartScreen({super.key});

  @override
  ConsumerState<ChartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends ConsumerState<ChartScreen> {
  @override
  Widget build(BuildContext context) {
    final weekDate = ref.watch(chartProvider);
    final user = ref.watch(projectProvider);
    final goalsList = ref.watch(dbGoalListProvider);
    final uniqueTitles = goalsList
        .map(
          (goal) => goal.title,
        )
        .toSet()
        .toList();

    List<DbGoalModel> getGoalsForTitle(String title) {
      return weekDate.where((item) => item.title == title).toList();
    }

    return Scaffold(
      body: SafeArea(
        child: user!.hasProject == true
            ? CustomScrollView(
                slivers: [
                  const SliverAppBar(
                    title: Text(
                      'Chart',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: 15,
                        bottom: 10,
                      ),
                      child: Text(
                        "Weekly Average",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: AspectRatio(
                      aspectRatio: 2.5,
                      child: weekDate.isNotEmpty
                          ? BarChartWidget(
                              weekData: getWeeklyAverageRatings(weekDate),
                            )
                          : const Center(
                              child: CircularProgressIndicator(
                                color: Colors.black,
                              ),
                            ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        Gaps.v14,
                        Divider(
                          color: Colors.grey.shade400,
                          height: Sizes.size14,
                          indent: 10,
                          endIndent: 10,
                          thickness: 0.5,
                        ),
                        Gaps.v14,
                      ],
                    ),
                  ),
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: 15,
                        bottom: 10,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Rating per Goal",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            "Tap the goal to see statistics",
                            style: TextStyle(color: Colors.black54),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.only(
                      left: 10,
                      right: 10,
                      top: 10,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final currentTitleGoals =
                              getGoalsForTitle(uniqueTitles[index]);

                          // final image = goalsList[index].image;
                          // final title = goalsList[index].title;
                          if (currentTitleGoals.isNotEmpty) {
                            final goalItem = currentTitleGoals
                                .first; // 혹은 평균 등의 처리로 데이터를 수정하실 수 있습니다.

                            return Column(
                              children: [
                                GoalListTile(
                                  userId: "", // 사용자 ID를 업데이트하십시오.
                                  title: goalItem.title,
                                  image: goalItem.image ?? '',
                                  rating:
                                      goalItem.rating!, // 이제 rating 데이터도 반영됩니다.
                                ),
                                Gaps.v8,
                              ],
                            );
                          } else {
                            return const SizedBox
                                .shrink(); // 해당 제목의 데이터가 없을 경우, 아무 것도 반환하지 않습니다.
                          }
                        },
                        childCount: uniqueTitles.length,
                      ),
                    ),
                  ),
                ],
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.announcement_outlined,
                      size: 50,
                    ),
                    Gaps.v16,
                    Text(
                      "No data available\nPlease create a project",
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  List<double> getWeeklyAverageRatings(List<DbGoalModel> data) {
    DateTime now = DateTime.now();
    DateTime monday = now.subtract(Duration(days: now.weekday - 1));

    List<double> weeklyAverages = [];

    for (int i = 0; i < 7; i++) {
      DateTime currentDay = monday.add(Duration(days: i));

      var matchingData = data
          .where(
              (item) => item.date == DateFormat('yyyyMMdd').format(currentDay))
          .toList();

      if (matchingData.isNotEmpty) {
        double dayAverage =
            matchingData.map((e) => e.rating).reduce((a, b) => a! + b!)! /
                matchingData.length;
        dayAverage = double.parse(dayAverage.toStringAsFixed(1));

        weeklyAverages.add(dayAverage);
      } else {
        weeklyAverages.add(0.0);
      }
    }

    return weeklyAverages;
  }
}

class GoalListTile extends ConsumerStatefulWidget {
  final String userId;
  final String title;
  final String image;
  final double rating;

  const GoalListTile({
    super.key,
    required this.userId,
    required this.title,
    required this.image,
    required this.rating,
  });

  @override
  ConsumerState<GoalListTile> createState() => _GoalListTileState();
}

class _GoalListTileState extends ConsumerState<GoalListTile> {
  bool _visible = false;

  void _onRatingTap() {
    setState(() {
      _visible = !_visible;
    });
  }

  @override
  Widget build(BuildContext context) {
    print(widget.rating);

    return Column(
      children: [
        GestureDetector(
          onTap: () => _onRatingTap(),
          child: Container(
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
                  widget.image != ""
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
                                widget.image,
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
                            widget.title,
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.star_rounded,
                          color: widget.rating == 0
                              ? Colors.grey.shade300
                              : Colors.amber,
                          size: 30,
                        ),
                        if (widget.rating != 0) Text("${widget.rating}"),
                      ],
                    ),
                  ),
                  Gaps.h10,
                ],
              ),
            ),
          ),
        ),
        AnimatedSize(
          curve: Curves.easeInOut,
          duration: const Duration(milliseconds: 300),
          child: Visibility(
            visible: _visible,
            child: const Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: AspectRatio(
                aspectRatio: 2.3,
                child: BarChartWidget(
                  weekData: [
                    4.5,
                    4.0,
                    3.5,
                    4.5,
                    2.5,
                    5.0,
                    4.0,
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
