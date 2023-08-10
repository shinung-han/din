import 'package:din/features/projects/models/db_goal_model.dart';
import 'package:din/features/projects/repos/project_repo.dart';
import 'package:din/features/projects/view_models/project_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GoalsViewModel extends StateNotifier<List<DbGoalModel>> {
  final ProjectRepository _projectRepository;

  GoalsViewModel(ref)
      : _projectRepository = ref.read(projectRepo),
        super([DbGoalModel.empty()]) {
    final user = ref.watch(projectProvider);
    loadGoalsOfToday(user!.uid);
  }

  Future<void> loadGoalsOfToday(String userId) async {
    print('goalsViewModel');
    String? projectId =
        await _projectRepository.getProjectDocIdByCondition(userId);
    if (projectId != null) {
      List<DbGoalModel> goals =
          await _projectRepository.fetchGoalsOfToday(userId, projectId);
      state = goals;
    }
  }
}

final goalListProvider =
    StateNotifierProvider<GoalsViewModel, List<DbGoalModel>>(
  (ref) => GoalsViewModel(ref),
);
