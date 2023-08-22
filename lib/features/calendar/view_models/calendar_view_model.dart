import 'package:din/features/calendar/models/event_model.dart';
import 'package:din/features/projects/repos/project_repo.dart';
import 'package:din/features/projects/view_models/project_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CalendarViewModel extends StateNotifier<Map<DateTime, List<EventModel>>> {
  final ProjectRepository _projectRepository;

  CalendarViewModel(ref)
      : _projectRepository = ref.read(projectRepo),
        super({}) {
    final user = ref.watch(projectProvider);
    loadGoalListOfTwoMonth(user!.uid);
  }

  Future<void> loadGoalListOfTwoMonth(String userId) async {
    String? projectId =
        await _projectRepository.getProjectDocIdByCondition(userId);

    if (projectId != null) {
      final data = await _projectRepository.fetchEventEverything(
        userId,
        projectId,
      );
      state = data;
    }
  }

  void updateEventMemoOrRating(
      DateTime date, String goalTitle, String? memo, double? rating) {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    final updatedEvents = state[normalizedDate]?.map((event) {
      if (event.title == goalTitle) {
        if (memo != null) {
          return event.copyWith(memo: memo);
        } else {
          return event.copyWith(rating: rating);
        }
      }
      return event;
    }).toList();

    if (updatedEvents != null) {
      state[normalizedDate] = updatedEvents;
      state = {...state};
    }
  }

  void updateAllEventsTitleAndImage(
    String? originalTitle,
    String? newTitle,
    String? oldImage,
    String? newImage,
  ) {
    Map<DateTime, List<EventModel>> updatedState = {};

    state.forEach((date, events) {
      final updatedEvents = events.map((event) {
        if (event.title == originalTitle) {
          return event.copyWith(title: newTitle ?? event.title);
        } else if (event.image == oldImage) {
          return event.copyWith(image: newImage);
        }
        return event;
      }).toList();

      updatedState[date] = updatedEvents;
    });

    state = updatedState;
  }
}

final calendarProvider =
    StateNotifierProvider<CalendarViewModel, Map<DateTime, List<EventModel>>>(
  (ref) => CalendarViewModel(ref),
);
