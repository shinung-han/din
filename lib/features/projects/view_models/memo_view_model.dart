import 'package:din/features/projects/repos/project_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MemoViewModel extends StateNotifier<String> {
  final ProjectRepository _projectRepository;

  MemoViewModel(ref)
      : _projectRepository = ref.read(projectRepo),
        super("");

  void writeMemo(String userId, String goalTitle, String memo) async {
    String? projectId =
        await _projectRepository.getProjectDocIdByCondition(userId);

    if (projectId != null) {
      String? goalId = await _projectRepository.getGoalDocIdByCondition(
          userId, projectId, goalTitle);
      if (goalId != null) {
        await _projectRepository.writeMemo(
          userId,
          projectId,
          goalTitle,
          memo,
          goalId,
        );
        state = memo;
      }
    } else {
      throw Exception('Error가 발생했습니다');
    }
  }
}

final memoProvider = StateNotifierProvider<MemoViewModel, String>(
  (ref) => MemoViewModel(ref),
);
