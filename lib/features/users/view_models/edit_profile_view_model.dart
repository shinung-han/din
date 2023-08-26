import 'dart:async';

import 'package:din/features/users/view_models/users_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditProfileViewModel extends StateNotifier {
  EditProfileViewModel(super.state);

  Future<void> profileUpdate(ref, newName) async {
    await ref.read(usersProvider.notifier).onEditUsername(newName);
  }
}

final editProfileProvider = StateNotifierProvider<EditProfileViewModel, void>(
  (ref) => EditProfileViewModel(ref),
);
