import 'dart:async';

import 'package:din/features/projects/repos/project_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProjectViewModel extends AsyncNotifier {
  late final ProjectRepository _projectRepository;

  @override
  FutureOr build() {
    throw UnimplementedError();
  }
}

final projectProvider = AsyncNotifierProvider(
  () => ProjectViewModel(),
);
