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

  void updateRating(String goalTitle, double rating) {
    state = state.map((goal) {
      if (goal.title == goalTitle) {
        return goal.copyWith(rating: rating); // copyWith 메서드로 새 객체를 반환합니다.
      }
      return goal;
    }).toList();
  }
}

final dbGoalListProvider =
    StateNotifierProvider<DBGoalListViewModel, List<DbGoalModel>>(
  (ref) => DBGoalListViewModel(ref),
);

// final ratingUpdateProvider = Provider((ref) => ref.watch(ratingProvider));


