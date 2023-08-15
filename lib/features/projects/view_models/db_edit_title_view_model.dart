import 'package:din/features/projects/repos/project_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditTitleViewModel extends StateNotifier<void> {
  final ProjectRepository _projectRepository;

  EditTitleViewModel(ref)
      : _projectRepository = ref.read(projectRepo),
        super("");

  void editTitle(String userId, String oldTitle, String newTitle) async {
    await _projectRepository.updateTitle(
      userId,
      oldTitle,
      newTitle,
    );
  }
}

final editTitleProvider = StateNotifierProvider(
  (ref) => EditTitleViewModel(ref),
);
