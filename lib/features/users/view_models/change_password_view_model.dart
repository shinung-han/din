import 'dart:async';

import 'package:din/features/authentication/repos/authentication_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChangePasswordViewModel extends StateNotifier<void> {
  final AuthenticationRepository _repository;

  ChangePasswordViewModel(ref)
      : _repository = ref.read(authRepo),
        super(null);

  Future<void> passwordUpdate(dynamic newPassword) async {
    final user = _repository.user;
    await user!.updatePassword(newPassword);
  }
}

final changePasswordProvider =
    StateNotifierProvider<ChangePasswordViewModel, void>(
  (ref) => ChangePasswordViewModel(ref),
);
