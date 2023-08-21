import 'package:din/features/calendar/models/event_model.dart';
import 'package:din/features/projects/repos/project_repo.dart';
import 'package:din/features/projects/view_models/project_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CalendarViewModel extends StateNotifier<Map<DateTime, List<EventModel>>> {
  // State의 타입을 수정합니다.
  final ProjectRepository _projectRepository;

  CalendarViewModel(ref)
      : _projectRepository = ref.read(projectRepo),
        super({}) {
    // 초기값을 빈 Map으로 설정합니다.
    final user = ref.watch(projectProvider);
    loadGoalListOfTwoMonth(user!.uid);
  }

  Future<void> loadGoalListOfTwoMonth(String userId) async {
    String? projectId =
        await _projectRepository.getProjectDocIdByCondition(userId);

    if (projectId != null) {
      final data =
          await _projectRepository.fetchEventsForCurrentAndPreviousMonth(
        userId,
        projectId,
      );
      state = data;
    }
  }
}

final calendarProvider =
    StateNotifierProvider<CalendarViewModel, Map<DateTime, List<EventModel>>>(
  (ref) => CalendarViewModel(ref),
);
