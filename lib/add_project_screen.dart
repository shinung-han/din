import 'package:din/cards_screen.dart';
import 'package:din/common/widgets/common_button.dart';
import 'package:din/constants/gaps.dart';
import 'package:din/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddProjectScreen extends StatefulWidget {
  static const routeName = 'add';
  static const routeURL = '/add';

  const AddProjectScreen({super.key});

  @override
  State<AddProjectScreen> createState() => _AddProjectScreenState();
}

class _AddProjectScreenState extends State<AddProjectScreen> {
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

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason>? _onSetCardsTap(
      difference) {
    if (difference.inDays == 0) {
      return ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          showCloseIcon: true,
          content: Text('Please select a date'),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const CardsScreen(),
        ),
      );
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final start = _dateRange.start;
    final end = _dateRange.end;
    final difference = _dateRange.duration;

    const textStyle = TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w500,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Create Project',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(Sizes.size20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonButton(
              text: 'Set a Date',
              onTap: _pickDateRange,
            ),
            Gaps.v20,
            Padding(
              padding: const EdgeInsets.only(left: Sizes.size8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Start date',
                    style: textStyle,
                  ),
                  Gaps.v4,
                  Text(start == end ? '-' : DateFormat.yMd().format(start)),
                  Gaps.v14,
                  const Text(
                    'End date',
                    style: textStyle,
                  ),
                  Gaps.v4,
                  Text(start == end ? '-' : DateFormat.yMd().format(end)),
                  Gaps.v14,
                  const Text(
                    'Duration',
                    style: textStyle,
                  ),
                  Gaps.v4,
                  Text(
                      start == end ? '-' : 'For ${difference.inDays + 1} days'),
                ],
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: CommonButton(
          text: 'Next',
          bgColor: Colors.black,
          color: Colors.white,
          onTap: () => _onSetCardsTap(difference),
        ),
      ),
    );
  }
}
