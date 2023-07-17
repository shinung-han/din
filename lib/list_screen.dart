import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  late DateTime _selectedDay = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  DateTime _focusedDay = DateTime.now();

  final events = LinkedHashMap(
    equals: isSameDay,
  )..addAll(eventSource);

  List<Event> getEventsForDay(DateTime day) {
    DateTime normalizedDay = DateTime(day.year, day.month, day.day);
    return events[normalizedDay] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TableCalendar(
              headerStyle: const HeaderStyle(),
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              focusedDay: DateTime.now(),
              onDaySelected: (selectedDay, focusedDay) {
                // print(selectedDay.toLocal());
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = selectedDay;
                });
              },
              selectedDayPredicate: (date) {
                if (_selectedDay == null) return false;

                return date.year == _selectedDay.year &&
                    date.month == _selectedDay.month &&
                    date.day == _selectedDay.day;
              },
              eventLoader: (day) => getEventsForDay(day),
            ),
            ...getEventsForDay(_selectedDay).map((e) {
              return ProjectCard(
                title: e.title,
                value: e.complete,
              );
            }),
          ],
        ),
      ),
    );
  }
}

class Event {
  String title;
  bool complete;
  Event(this.title, this.complete);

  @override
  String toString() => title;
}

Map<DateTime, dynamic> eventSource = {
  DateTime(2023, 07, 16): [
    Event('5분 기도하기', false),
    Event('교회 가서 인증샷 찍기', true),
    Event('QT하기', true),
    Event('셀 모임하기', false),
  ],
  DateTime(2023, 07, 15): [
    Event('5분 기도하기', false),
    Event('치킨 먹기', true),
    Event('QT하기', true),
    Event('셀 모임하기', false),
  ],
  DateTime(2022, 1, 8): [
    Event('5분 기도하기', false),
    Event('자기 셀카 올리기', true),
    Event('QT하기', false),
    Event('셀 모임하기', false),
  ],
  DateTime(2022, 1, 11): [
    Event('5분 기도하기', false),
    Event('가족과 저녁식사 하기', true),
    Event('QT하기', true)
  ],
  DateTime(2022, 1, 13): [
    Event('5분 기도하기', false),
    Event('교회 가서 인증샷 찍기', true),
    Event('QT하기', false),
    Event('셀 모임하기', false),
  ],
  DateTime(2022, 1, 15): [
    Event('5분 기도하기', false),
    Event('치킨 먹기', false),
    Event('QT하기', true),
    Event('셀 모임하기', false),
  ],
  DateTime(2022, 1, 18): [
    Event('5분 기도하기', false),
    Event('자기 셀카 올리기', true),
    Event('QT하기', false),
    Event('셀 모임하기', false),
  ],
  DateTime(2022, 1, 20): [
    Event('5분 기도하기', true),
    Event('자기 셀카 올리기', true),
    Event('QT하기', true),
    Event('셀 모임하기', true),
  ],
  DateTime(2022, 1, 21): [
    Event('5분 기도하기', false),
    Event('가족과 저녁식사 하기', true),
    Event('QT하기', false)
  ]
};

class ProjectCard extends StatelessWidget {
  final String title;
  final bool value;

  const ProjectCard({
    required this.title,
    super.key,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Checkbox(value: value, onChanged: (_) {}),
          Text(title),
        ],
      ),
    );
  }
}
