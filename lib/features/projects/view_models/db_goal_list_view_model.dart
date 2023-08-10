import 'package:din/features/projects/models/db_goal_model.dart';
import 'package:din/features/projects/repos/project_repo.dart';
import 'package:din/features/projects/view_models/project_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DBGoalListViewModel extends StateNotifier<List<DbGoalModel>> {
  final ProjectRepository _projectRepository;

  DBGoalListViewModel(ref)
      : _projectRepository = ref.read(projectRepo),
        super([]) {
    final user = ref.watch(projectProvider);
    loadGoalsOfToday(user!.uid);
  }

  Future<void> loadGoalsOfToday(String userId) async {
    String? projectId =
        await _projectRepository.getProjectDocIdByCondition(userId);
    if (projectId != null) {
      state = await _projectRepository.fetchGoalsOfToday(userId, projectId);
    }
  }
}

final dbGoalListProvider =
    StateNotifierProvider<DBGoalListViewModel, List<DbGoalModel>>(
  (ref) => DBGoalListViewModel(ref),
);
