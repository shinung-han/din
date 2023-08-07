import 'package:din/common/widgets/common_appbar.dart';
import 'package:din/common/widgets/common_button.dart';
import 'package:din/constants/gaps.dart';
import 'package:din/constants/sizes.dart';
import 'package:din/features/projects/list_of_goals_screen.dart';
import 'package:din/features/authentication/widgets/auth_header.dart';
import 'package:din/features/projects/view_models/date_view_model.dart';
import 'package:din/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class SetDateScreen extends ConsumerStatefulWidget {
  static const routeName = 'setDate';
  static const routeURL = 'set_date';

  const SetDateScreen({super.key});

  @override
  ConsumerState<SetDateScreen> createState() => _AddProjectScreenState();
}

class _AddProjectScreenState extends ConsumerState<SetDateScreen> {
  DateTimeRange _dateRange = DateTimeRange(
    start: DateTime.now(),
    end: DateTime.now(),
  );

  Future<DateTimeRange?> _pickDateRange() async {
    DateTimeRange? newDateRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.black,
              primaryContainer: Colors.white,
              secondary: Colors.grey.shade100,
            ),
          ),
          child: child!,
        );
      },
    );

    if (newDateRange == null) return null;

    setState(() {
      _dateRange = newDateRange;
    });
    return null;
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason>? _onSetCardsTap(
      start, end, difference) {
    if (difference == 0) {
      showErrorSnack(context, 'Please select a date');
    } else {
      ref.read(dateProvider.notifier).setDate(start, end, difference);

      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => const ListOfGoalsScreen(),
      //   ),
      // );
      context
          .go('/home/${SetDateScreen.routeURL}/${ListOfGoalsScreen.routeURL}');
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final start = _dateRange.start;
    final end = _dateRange.end;
    final difference = _dateRange.duration.inDays;

    const textStyle = TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w500,
    );

    return Scaffold(
      appBar: const CommonAppBar(title: 'Create Project'),
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
              icon: Icons.edit_calendar_rounded,
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
                        'Period',
                        style: textStyle,
                      ),
                      Gaps.v4,
                      Text(start == end ? '-' : 'For ${difference + 1} days'),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 90,
        child: CommonButton(
          text: 'Next',
          bgColor: Colors.black,
          color: Colors.white,
          onTap: () => _onSetCardsTap(start, end, difference),
          icon: Icons.arrow_forward_ios_rounded,
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
