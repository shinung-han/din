import 'package:din/features/projects/models/date_model.dart';
import 'package:din/features/projects/repos/project_repo.dart';
import 'package:din/features/projects/view_models/project_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppBarViewModel extends StateNotifier<DateModel?> {
  final ProjectRepository _projectRepository;
  bool _mounted = true;

  AppBarViewModel(ref)
      : _projectRepository = ref.read(projectRepo),
        super(DateModel.empty()) {
    final user = ref.watch(projectProvider);
    loadProjectDates(user!.uid);
  }

  Future<void> loadProjectDates(String uid) async {
    String? docId = await _projectRepository.getProjectDocIdByCondition(uid);
    if (!_mounted) return;

    if (docId != null) {
      state = await _projectRepository.getProjectDate(uid, docId);
      if (!_mounted) return;
    }
  }

  @override
  void dispose() {
    _mounted = false;
    super.dispose();
  }
}

final appBarProvider = StateNotifierProvider<AppBarViewModel, DateModel?>(
  (ref) => AppBarViewModel(ref),
);
