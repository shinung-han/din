import 'package:din/features/projects/repos/project_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RatingViewModel extends StateNotifier<double> {
  final ProjectRepository _projectRepository;

  RatingViewModel(ref)
      : _projectRepository = ref.read(projectRepo),
        super(0);

  void saveRating(String userId, String goalTitle, double rating) async {
    String? projectId =
        await _projectRepository.getProjectDocIdByCondition(userId);

    if (projectId != null) {
      String? goalId = await _projectRepository.getGoalDocIdByCondition(
          userId, projectId, goalTitle);
      if (goalId != null) {
        await _projectRepository.saveRating(
          userId,
          projectId,
          goalTitle,
          rating,
          goalId,
        );
        state = rating;
      }
    } else {
      throw Exception('Error가 발생했습니다');
    }
  }
}

final ratingProvider = StateNotifierProvider<RatingViewModel, double>(
  (ref) => RatingViewModel(ref),
);
