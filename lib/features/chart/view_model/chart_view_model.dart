import 'package:din/features/projects/models/db_goal_model.dart';
import 'package:din/features/projects/repos/project_repo.dart';
import 'package:din/features/projects/view_models/project_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChartViewModel extends StateNotifier<Map<String, List<DbGoalModel>>> {
  final ProjectRepository _projectRepository;

  ChartViewModel(ref)
      : _projectRepository = ref.read(projectRepo),
        super({}) {
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
      state = data.cast<String, List<DbGoalModel>>();
    }
  }
}

final chartProvider =
    StateNotifierProvider<ChartViewModel, Map<String, List<DbGoalModel>>>(
        (ref) {
  return ChartViewModel(ref);
});
