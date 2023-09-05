import 'package:cached_network_image/cached_network_image.dart';
import 'package:din/constants/gaps.dart';
import 'package:din/constants/sizes.dart';
import 'package:din/features/chart/view_model/chart_view_model.dart';
import 'package:din/features/chart/widgets/bar_chart.dart';
import 'package:din/features/projects/models/db_goal_model.dart';
import 'package:din/features/projects/view_models/db_goal_list_view_model.dart';
import 'package:din/features/projects/view_models/project_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ChartScreen extends ConsumerStatefulWidget {
  const ChartScreen({super.key});

  @override
  ConsumerState<ChartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends ConsumerState<ChartScreen> {
  final GlobalKey _weeklyToolTipKey = GlobalKey();
  final GlobalKey _ratingPerToolTipKey = GlobalKey();

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
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: 15,
                        bottom: 10,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Weekly Average",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              final dynamic tooltip =
                                  _weeklyToolTipKey.currentState;
                              tooltip?.ensureTooltipVisible();
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                top: 2,
                                left: 5,
                                right: 10,
                              ),
                              child: Tooltip(
                                key: _weeklyToolTipKey,
                                message:
                                    "\nDisplays the weekly star rating average for daily\nobjectives, counting onlycompleted goals\n",
                                child: Icon(
                                  Icons.info_outline,
                                  size: Sizes.size24,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            ),
                          ),
                        ],
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
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: 15,
                        bottom: 10,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Rating per Goal",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  final dynamic tooltip =
                                      _ratingPerToolTipKey.currentState;
                                  tooltip?.ensureTooltipVisible();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    top: 2,
                                    left: 5,
                                    right: 10,
                                  ),
                                  child: Tooltip(
                                    key: _ratingPerToolTipKey,
                                    message:
                                        "\nDisplays the weekly average star rating for\nyour goals, factoring in only completed ones\n",
                                    child: Icon(
                                      Icons.info_outline,
                                      size: Sizes.size24,
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            "Tap the goal to see statistics",
                            style: TextStyle(color: Colors.black54),
                          ),
                        ],
                      ),
                    ),
                  ),
                  weekDate.isNotEmpty
                      ? SliverPadding(
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

                                if (currentTitleGoals.isNotEmpty) {
                                  final goalItem = currentTitleGoals.first;

                                  final weeklyRatings =
                                      computeWeeklyRatings(currentTitleGoals);

                                  double averageRating;
                                  int count = weeklyRatings
                                      .where((rating) => rating > 0.0)
                                      .length;
                                  if (count > 0) {
                                    averageRating = weeklyRatings
                                            .where((rating) => rating > 0.0)
                                            .reduce((a, b) => a + b) /
                                        count;
                                    averageRating = double.parse(
                                        averageRating.toStringAsFixed(1));
                                  } else {
                                    averageRating = 0.0;
                                  }

                                  return Column(
                                    children: [
                                      GoalListTile(
                                        userId: "",
                                        title: goalItem.title,
                                        image: goalItem.image ?? '',
                                        rating: averageRating,
                                        weeklyRatings: weeklyRatings,
                                      ).animate().flipV(
                                            begin: -0.5,
                                            end: 0,
                                            curve: Curves.easeOutExpo,
                                          ),
                                      Gaps.v8,
                                    ],
                                  );
                                } else {
                                  return const SizedBox.shrink();
                                }
                              },
                              childCount: uniqueTitles.length,
                            ),
                          ),
                        )
                      : SliverFillRemaining(
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Colors.black,
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
        var validRatings = matchingData
            .map((e) => e.rating)
            .where((rating) => rating != null && rating > 0)
            .toList();

        if (validRatings.isNotEmpty) {
          double dayAverage =
              validRatings.reduce((a, b) => a! + b!)! / validRatings.length;
          dayAverage = double.parse(dayAverage.toStringAsFixed(1));

          weeklyAverages.add(dayAverage);
        } else {
          weeklyAverages.add(0.0);
        }
      } else {
        weeklyAverages.add(0.0);
      }
    }

    return weeklyAverages;
  }
}

List<double> computeWeeklyRatings(List<DbGoalModel> goals) {
  DateTime now = DateTime.now();
  DateTime monday = now.subtract(Duration(days: now.weekday - 1));

  List<double> weeklyRatings = List<double>.filled(7, 0.0);

  for (int i = 0; i < 7; i++) {
    DateTime currentDay = monday.add(Duration(days: i));

    var matchingGoals = goals
        .where((goal) => DateFormat('yyyyMMdd').format(currentDay) == goal.date)
        .toList();

    if (matchingGoals.isNotEmpty) {
      double sum = 0;
      int count = 0;

      for (var goal in matchingGoals) {
        if (goal.rating != null) {
          sum += goal.rating!;
          count++;
        }
      }

      if (count > 0) {
        weeklyRatings[i] = double.parse((sum / count).toStringAsFixed(1));
      }
    }
  }
  return weeklyRatings;
}

class GoalListTile extends ConsumerStatefulWidget {
  final String userId;
  final String title;
  final String image;
  final double rating;
  final List<double> weeklyRatings;

  const GoalListTile({
    super.key,
    required this.userId,
    required this.title,
    required this.image,
    required this.rating,
    required this.weeklyRatings,
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
                              image: CachedNetworkImageProvider(
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
            child: Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: AspectRatio(
                aspectRatio: 2.3,
                child: BarChartWidget(
                  weekData: widget.weeklyRatings,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class TooltipSample extends StatelessWidget {
  const TooltipSample({super.key});

  @override
  Widget build(BuildContext context) {
    return const Tooltip(
      message: 'I am a Tooltip',
      child: Text('Hover over the text to show a tooltip.'),
    );
  }
}
