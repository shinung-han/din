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

    if (newDateRange.start == newDateRange.end) {
      showErrorSnack(context, "동일한 날짜는 선택할 수 없습니다");
      return null;
    }

    setState(() {
      _dateRange = newDateRange;
    });

    return null;
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason>? _onSetCardsTap(
      start, end, difference) {
    if (difference == 1) {
      showErrorSnack(context, '달력을 탭하여 날짜를 선택해 주세요');
    } else {
      ref.read(dateProvider.notifier).setDate(start, end, difference);

      context
          .go('/home/${SetDateScreen.routeURL}/${ListOfGoalsScreen.routeURL}');
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final start = _dateRange.start;
    final end = _dateRange.end;
    final difference = _dateRange.duration.inDays + 1;

    const textStyle = TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w500,
    );

    return Scaffold(
      appBar: const CommonAppBar(title: '프로젝트 생성'),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const AuthHeader(
                  title: '날짜 설정',
                  subTitle:
                      "프로젝트 시작과 종료 날짜를 선택하세요.\n당신의 변화와 성장의 첫 걸음을 시작해 보세요!",
                ),
                CommonButton(
                  text: '달력',
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
                            "시작일",
                            style: textStyle,
                          ),
                          Gaps.v4,
                          Text(start == end
                              ? '-'
                              : DateFormat('yyyy/MM/dd').format(start)),
                        ],
                      ),
                      verticalDivider(),
                      Column(
                        children: [
                          const Text(
                            "종료일",
                            style: textStyle,
                          ),
                          Gaps.v4,
                          Text(start == end
                              ? '-'
                              : DateFormat('yyyy/MM/dd').format(end)),
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
                          Text(start == end ? '-' : '${difference}일 동안'),
                        ],
                      ),
                    ],
                  ),
                ),
                Gaps.v60,
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 128,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.grey.shade500,
                ),
                Gaps.h5,
                Text(
                  "프로젝트 생성 후 날짜는 변경할 수 없습니다",
                  style: TextStyle(color: Colors.grey.shade700),
                ),
              ],
            ),
            Gaps.v10,
            Container(
              height: 66,
              child: CommonButton(
                text: '다음',
                bgColor: Colors.black,
                color: Colors.white,
                onTap: () => _onSetCardsTap(start, end, difference),
                icon: Icons.arrow_forward_ios_rounded,
              ),
            ),
          ],
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
