import 'package:din/common/widgets/common_button.dart';
import 'package:din/constants/gaps.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'constants/sizes.dart';

class AddProjectScreen extends StatefulWidget {
  static const routeName = 'add';
  static const routeURL = '/add';

  const AddProjectScreen({super.key});

  @override
  State<AddProjectScreen> createState() => _AddProjectScreenState();
}

class _AddProjectScreenState extends State<AddProjectScreen> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  DateTimeRange _dateRange = DateTimeRange(
    start: DateTime.now(),
    end: DateTime.now(),
  );

  Future<DateTimeRange?> _pickDateRange() async {
    DateTimeRange? newDateRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (newDateRange == null) return null;

    setState(() {
      _dateRange = newDateRange;
    });
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final start = _dateRange.start;
    final end = _dateRange.end;
    final difference = _dateRange.duration;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Project',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Form(
              key: _globalKey,
              child: Column(
                children: [
                  TextFormField(
                    cursorHeight: Sizes.size16,
                    decoration: const InputDecoration(
                      labelText: 'Project title',
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _pickDateRange,
                    child: const Text(
                      'Range',
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(DateFormat.yMd().format(start)),
                      Gaps.h20,
                      Text(DateFormat.yMd().format(end)),
                      Gaps.h20,
                      Text('${difference.inDays}일'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomAppBar(
        child: CommonButton(
          text: 'Next',
        ),
      ),
    );
  }
}
