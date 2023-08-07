import 'package:din/features/projects/models/date.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DateViewModel extends StateNotifier<DateModel> {
  DateViewModel()
      : super(
          DateModel(
            startDate: DateTime.now(),
            endDate: DateTime.now(),
            period: 1,
          ),
        );

  void setDate(DateTime start, DateTime end, int period) {
    state = DateModel(startDate: start, endDate: end, period: period);
  }
}

final dateProvider = StateNotifierProvider<DateViewModel, DateModel>(
  (ref) => DateViewModel(),
);
