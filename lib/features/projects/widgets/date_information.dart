import 'package:din/constants/gaps.dart';
import 'package:din/constants/sizes.dart';
import 'package:din/features/projects/models/date_model.dart';
import 'package:din/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateInformation extends StatelessWidget {
  final DateModel date;

  const DateInformation({
    super.key,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w500,
    );

    return IntrinsicHeight(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Sizes.size20),
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
                Text('For ${date.period} days'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
