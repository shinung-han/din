import 'package:din/features/projects/models/db_goal_model.dart';
import 'package:din/features/projects/repos/project_repo.dart';
import 'package:din/features/projects/view_models/project_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ChartViewModel extends StateNotifier<List<DbGoalModel>> {
  final ProjectRepository _projectRepository;

  ChartViewModel(ref)
      : _projectRepository = ref.read(projectRepo),
        super([]) {
    final user = ref.watch(projectProvider);
    loadGoalListOfTwoMonth(user!.uid);
  }

  Future<void> loadGoalListOfTwoMonth(String userId) async {
    String? projectId =
        await _projectRepository.getProjectDocIdByCondition(userId);

    if (projectId != null) {
      final data = await _projectRepository.fetchGoalsOfTodayAndWeek(
        userId,
        projectId,
      );
      state = data["week"]!;
    }
  }

  void updateRating(String goalTitle, double rating) {
    final now = DateFormat('yyyyMMdd').format(DateTime.now());

    state = state.map((goal) {
      if (goal.title == goalTitle && goal.date == now) {
        return goal.copyWith(rating: rating);
      }
      return goal;
    }).toList();
  }
}

final chartProvider =
    StateNotifierProvider<ChartViewModel, List<DbGoalModel>>((ref) {
  return ChartViewModel(ref);
});
