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
                  '시작일',
                  style: textStyle,
                ),
                Gaps.v4,
                Text(DateFormat('yyyy/MM/dd').format(date.startDate)),
              ],
            ),
            verticalDivider(),
            Column(
              children: [
                const Text(
                  '종료일',
                  style: textStyle,
                ),
                Gaps.v4,
                Text(DateFormat('yyyy/MM/dd').format(date.endDate)),
              ],
            ),
            verticalDivider(),
            Column(
              children: [
                const Text(
                  '기간',
                  style: textStyle,
                ),
                Gaps.v4,
                Text('${date.period}일 동안'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
