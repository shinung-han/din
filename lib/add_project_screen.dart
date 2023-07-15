import 'package:din/common/widgets/common_button.dart';
import 'package:din/constants/gaps.dart';
import 'package:din/constants/sizes.dart';
import 'package:din/features/authentication/widgets/auth_header.dart';
import 'package:din/set_number_of_projects_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
          builder: (context) => const SetNumberOfProjects(),
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
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AuthHeader(
              title: 'Set the Date',
              subTitle:
                  'Create your own fantastic project to become a better version of yourself than yesterday.',
            ),
            Gaps.v20,
            CommonButton(
              text: 'Calendar',
              onTap: _pickDateRange,
              icon: FontAwesomeIcons.calendarCheck,
            ),
            Gaps.v24,
            IntrinsicHeight(
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
                      Text(start == end ? '-' : DateFormat.yMd().format(start)),
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
                      Text(start == end ? '-' : DateFormat.yMd().format(end)),
                    ],
                  ),
                  verticalDivider(),
                  Column(
                    children: [
                      const Text(
                        'Duration',
                        style: textStyle,
                      ),
                      Gaps.v4,
                      Text(start == end
                          ? '-'
                          : 'For ${difference.inDays + 1} days'),
                    ],
                  ),
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
