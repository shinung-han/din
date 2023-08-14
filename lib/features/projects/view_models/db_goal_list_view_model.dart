import 'package:din/features/projects/models/db_goal_model.dart';
import 'package:din/features/projects/repos/project_repo.dart';
import 'package:din/features/projects/view_models/project_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DBGoalListViewModel extends StateNotifier<List<DbGoalModel>> {
  final ProjectRepository _projectRepository;
  bool _mounted = true;

  DBGoalListViewModel(ref)
      : _projectRepository = ref.read(projectRepo),
        super([]) {
    final user = ref.watch(projectProvider);
    loadGoalsOfToday(user!.uid);
  }

  Future<void> loadGoalsOfToday(String userId) async {
    String? projectId =
        await _projectRepository.getProjectDocIdByCondition(userId);
    if (!_mounted) return;

    if (projectId != null && _mounted) {
      final data =
          await _projectRepository.fetchGoalsOfToday(userId, projectId);
      state = data;
    }
  }

  void updateRating(String goalTitle, double rating) {
    state = state.map((goal) {
      if (goal.title == goalTitle) {
        return goal.copyWith(rating: rating);
      }
      return goal;
    }).toList();
  }

  void updateMemo(String goalTitle, String memo) {
    state = state.map((goal) {
      if (goal.title == goalTitle) {
        return goal.copyWith(memo: memo);
      }
      return goal;
    }).toList();
  }

  void updateTitle(String oldTitle, String newTitle) {
    state = state.map((goal) {
      if (goal.title == oldTitle) {
        return goal.copyWith(title: newTitle);
      }
      return goal;
    }).toList();
  }

  @override
  void dispose() {
    _mounted = false;
    super.dispose();
  }
}

final dbGoalListProvider =
    StateNotifierProvider<DBGoalListViewModel, List<DbGoalModel>>(
  (ref) => DBGoalListViewModel(ref),
);
