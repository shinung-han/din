import 'dart:collection';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:din/constants/gaps.dart';
import 'package:din/constants/sizes.dart';
import 'package:din/features/calendar/models/event_model.dart';
import 'package:din/features/calendar/view_models/calendar_view_model.dart';
import 'package:din/features/calendar/view_models/format_view_model.dart';
import 'package:din/features/projects/view_models/project_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  late DateTime _selectedDay = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  DateTime _focusedDay = DateTime.now();

  Future<void> _onFormatChanged(CalendarFormat format) async {
    await ref.read(formatProvider.notifier).saveCalendarFormat(format);
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(projectProvider);
    final eventSource = ref.watch(calendarProvider);

    final events = LinkedHashMap(
      equals: isSameDay,
    )..addAll(eventSource);

    List<EventModel> getEventsForDay(DateTime day) {
      DateTime normalizedDay = DateTime(day.year, day.month, day.day);
      return events[normalizedDay] ?? [];
    }

    final format = ref.watch(formatProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TableCalendar(
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              locale: 'ko_KR',
              focusedDay: _focusedDay,
              headerStyle: HeaderStyle(
                titleTextFormatter: (focusedDay, locale) {
                  return DateFormat.yMMM(locale).format(focusedDay);
                },
                formatButtonDecoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 0.5),
                  borderRadius: BorderRadius.circular(20),
                ),
                formatButtonTextStyle:
                    const TextStyle(fontSize: 14, color: Colors.black),
                formatButtonPadding:
                    const EdgeInsets.symmetric(vertical: 6, horizontal: 20),
                titleTextStyle:
                    const TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                leftChevronIcon: const Icon(
                  Icons.chevron_left_rounded,
                  color: Colors.black,
                  size: 30,
                ),
                rightChevronIcon: const Icon(
                  Icons.chevron_right_rounded,
                  color: Colors.black,
                  size: 30,
                ),
              ),
              daysOfWeekStyle: DaysOfWeekStyle(
                weekdayStyle: TextStyle(fontSize: 13),
                weekendStyle: TextStyle(fontSize: 13),
              ),
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade300),
                ),
                todayTextStyle: const TextStyle(color: Colors.black),
                selectedDecoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.black,
                    width: 1.5,
                  ),
                ),
                selectedTextStyle: const TextStyle(color: Colors.black),
                markersMaxCount: 1,
                markersAlignment: Alignment.center,
              ),
              availableCalendarFormats: const {
                CalendarFormat.twoWeeks: "2주로 전환",
                CalendarFormat.week: "1주로 전환",
                CalendarFormat.month: "1개월로 전환",
              },
              calendarFormat: format,
              onFormatChanged: (format) => _onFormatChanged(format),
              onDaySelected: (selectedDay, focusedDay) {
                if (selectedDay.month != _focusedDay.month) {
                  setState(() {
                    _focusedDay = selectedDay;
                    _selectedDay = DateTime(
                        selectedDay.year, selectedDay.month, selectedDay.day);
                  });
                } else {
                  setState(() {
                    _selectedDay = DateTime(
                        selectedDay.year, selectedDay.month, selectedDay.day);
                  });
                }
              },
              selectedDayPredicate: (date) {
                return date.year == _selectedDay.year &&
                    date.month == _selectedDay.month &&
                    date.day == _selectedDay.day;
              },
              eventLoader: (day) => getEventsForDay(day),
            ),
            Gaps.v10,
            Divider(
              color: Colors.grey.shade400,
              height: Sizes.size14,
              indent: 10,
              endIndent: 10,
              thickness: 0.5,
            ),
            Gaps.v10,
            if (user!.hasProject == false)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.announcement_outlined,
                        size: 50,
                      ),
                      Gaps.v16,
                      Text(
                        "데이터가 없습니다\n프로젝트를 생성해 주세요",
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            if (user.hasProject == true)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: eventSource.isEmpty
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Colors.black,
                          ),
                        )
                      : ListView.separated(
                          itemCount: eventSource[_selectedDay]?.length ?? 0,
                          itemBuilder: (context, index) {
                            EventModel? currentEvent =
                                eventSource[_selectedDay]?[index];

                            if (currentEvent != null) {
                              return GoalListTile(
                                key: ValueKey<String>(
                                    currentEvent.date!.toString()),
                                title: currentEvent.title,
                                image: currentEvent.image ?? "",
                                memo: currentEvent.memo,
                                rating: currentEvent.rating,
                              ).animate().flipV(
                                    begin: -0.5,
                                    end: 0,
                                    curve: Curves.easeOutExpo,
                                  );
                            }
                            return const SizedBox.shrink();
                          },
                          separatorBuilder: (context, index) {
                            return Gaps.v8;
                          },
                        ),
                ),
              ),
            Gaps.v20,
          ],
        ),
      ),
    );
  }
}

class GoalListTile extends ConsumerStatefulWidget {
  final String title;
  final String image;
  final String? memo;
  final bool? isMemo;
  final double rating;

  const GoalListTile({
    Key? key,
    required this.title,
    required this.memo,
    required this.image,
    required this.rating,
    this.isMemo,
  }) : super(key: key);

  @override
  ConsumerState<GoalListTile> createState() => _GoalListTileState();
}

class _GoalListTileState extends ConsumerState<GoalListTile>
    with SingleTickerProviderStateMixin {
  bool _visible = false;

  void _onMemoTap() {
    setState(() {
      _visible = !_visible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
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
                  child: Row(
                    children: [
                      if (widget.memo != "")
                        GestureDetector(
                          onTap: _onMemoTap,
                          child: CircleAvatar(
                            radius: 18,
                            backgroundColor: Colors.grey.shade400,
                            child: const CircleAvatar(
                              radius: 17.5,
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.notes_rounded,
                                color: Colors.black,
                                size: 22,
                              ),
                            ),
                          ),
                        ),
                      Gaps.h6,
                      Column(
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
                      Gaps.h10,
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        AnimatedSize(
          curve: Curves.easeInOut,
          duration: const Duration(milliseconds: 300),
          child: Visibility(
            visible: _visible,
            child: Padding(
              padding: const EdgeInsets.only(
                left: 10,
                right: 10,
                top: 15,
                bottom: 20,
              ),
              child: SizedBox(
                width: double.infinity,
                child: Text(
                  "${widget.memo}",
                  textAlign: TextAlign.start,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
