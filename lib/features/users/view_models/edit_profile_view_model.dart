import 'dart:async';

import 'package:din/features/users/view_models/users_view_model.dart';
import 'package:din/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditProfileViewModel extends AsyncNotifier {
  @override
  FutureOr build() {
    throw UnimplementedError();
  }

  Future<void> profileUpdate(BuildContext context, String newName) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () async {
        await ref.read(usersProvider.notifier).onEditUsername(newName);
        showErrorSnack(context, "Your username has been successfully changed");
        Future.delayed(const Duration(milliseconds: 500));
        Navigator.pop(context);
      },
    );
  }
}

final editProfileProvider = AsyncNotifierProvider<EditProfileViewModel, void>(
  () => EditProfileViewModel(),
);
