import 'dart:async';

import 'package:din/features/authentication/repos/authentication_repo.dart';
import 'package:din/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChangePasswordViewModel extends AsyncNotifier {
  late final AuthenticationRepository _repository;

  @override
  FutureOr build() {
    _repository = ref.read(authRepo);
    throw UnimplementedError();
  }

  Future<void> passwordUpdate(BuildContext context, dynamic newPassword) async {
    final user = _repository.user;
    state = const AsyncValue.loading();
    if (user != null) {
      state = await AsyncValue.guard(() async {
        await user.updatePassword(newPassword);
        Navigator.pop(context);
        showErrorSnack(context, '비밀번호가 변경되었습니다');
      });
    }
  }
}

final changePasswordProvider =
    AsyncNotifierProvider<ChangePasswordViewModel, void>(
  () => ChangePasswordViewModel(),
);
