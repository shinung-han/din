import 'package:din/features/authentication/repos/authentication_repo.dart';
import 'package:din/features/projects/repos/project_repo.dart';
import 'package:din/features/users/model/user_profile_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProjectViewModel extends StateNotifier<UserProfileModel?> {
  final ProjectRepository _projectRepository;
  final AuthenticationRepository _authenticationRepository;

  ProjectViewModel(ref)
      : _projectRepository = ref.read(projectRepo),
        _authenticationRepository = ref.read(authRepo),
        super(UserProfileModel.empty());

  Future<void> loadUserProfile() async {
    if (_authenticationRepository.isLoggedIn) {
      state = await _projectRepository
          .getUserProfile(_authenticationRepository.user!.uid);
    }
  }

  Future<void> updateHasProject(bool value) async {
    if (state == null) return;

    await _projectRepository.updateProjectStatus(state!.uid, value);
    state = state!.copyWith(hasProject: value);
  }

  Future<void> addProject(
    String userId,
    DateTime startDate,
    DateTime endDate,
    int period,
    goals,
  ) async {
    await _projectRepository.createProjectWithGoals(
      userId,
      startDate,
      endDate,
      period,
      goals,
    );
    state = state!.copyWith(hasProject: true);
  }

  Future<void> deleteProject(String userId) async {
    String? projectId =
        await _projectRepository.getProjectDocIdByCondition(userId);
    if (projectId != null) {
      await _projectRepository.deleteProject(userId, projectId);
      state = state!.copyWith(hasProject: false);
    }
  }
}

final projectProvider =
    StateNotifierProvider<ProjectViewModel, UserProfileModel?>(
  (ref) => ProjectViewModel(ref),
);
