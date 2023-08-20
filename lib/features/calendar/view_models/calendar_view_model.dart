import 'package:din/features/projects/models/db_goal_model.dart';
import 'package:din/features/projects/repos/project_repo.dart';
import 'package:din/features/projects/view_models/project_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CalendarViewModel extends StateNotifier<List<DbGoalModel>> {
  final ProjectRepository _projectRepository;
  final bool _mounted = true;

  CalendarViewModel(ref)
      : _projectRepository = ref.read(projectRepo),
        super([]) {
    final user = ref.watch(projectProvider);
    loadGoalListOfTwoMonth(user!.uid);
  }

  Future<void> loadGoalListOfTwoMonth(String userId) async {
    String? projectId =
        await _projectRepository.getProjectDocIdByCondition(userId);
    if (!mounted) return;

    if (projectId != null && _mounted) {
      final data =
          await _projectRepository.fetchGoalsForCurrentAndPreviousMonth(
        userId,
        projectId,
      );
      if (!_mounted) return;
      // print(data);
      state = data;
    }
  }
}

final calendarProvider =
    StateNotifierProvider<CalendarViewModel, List<DbGoalModel>>(
  (ref) => CalendarViewModel(ref),
);
