import 'dart:io';

import 'package:din/features/projects/repos/project_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditImageViewModel extends StateNotifier<void> {
  final ProjectRepository _projectRepository;

  EditImageViewModel(ref)
      : _projectRepository = ref.read(projectRepo),
        super("");

  Future<String> editImage(
    String userId,
    String title,
    String? oldImageUrl,
    File newImageUrl,
  ) async {
    final newImage = await _projectRepository.updateImage(
      userId,
      title,
      oldImageUrl,
      newImageUrl,
    );

    return newImage;
  }
}

final editImageProvider = StateNotifierProvider(
  (ref) => EditImageViewModel(ref),
);
