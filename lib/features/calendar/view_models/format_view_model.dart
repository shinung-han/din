import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

class FormatViewModel extends StateNotifier<CalendarFormat> {
  FormatViewModel() : super(CalendarFormat.twoWeeks) {
    getCalendarFormat();
  }

  Future<void> getCalendarFormat() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int? index = prefs.getInt('calendar_format_key');
    if (index != null && index >= 0 && index < CalendarFormat.values.length) {
      state = CalendarFormat.values[index];
    }
  }

  Future<void> saveCalendarFormat(CalendarFormat format) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('calendar_format_key', format.index);
    state = format;
  }
}

final formatProvider =
    StateNotifierProvider<FormatViewModel, CalendarFormat>((ref) {
  return FormatViewModel();
});
