import 'dart:async';

import 'package:din/features/authentication/repos/authentication_repo.dart';
import 'package:din/features/onboarding/tutorial_screen.dart';
import 'package:din/features/users/view_models/users_view_model.dart';
import 'package:din/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SignUpViewModel extends AsyncNotifier<void> {
  late final AuthenticationRepository _authRepo;

  @override
  FutureOr<void> build() {
    _authRepo = ref.read(authRepo);
  }

  Future<void> signUp(
    String email,
    String password,
    String name,
    BuildContext context,
  ) async {
    state = const AsyncValue.loading();
    // final form = ref.read(signUpForm);
    final users = ref.read(usersProvider.notifier);
    state = await AsyncValue.guard(() async {
      final userCredential = await _authRepo.signUp(
        email,
        password,
      );
      await users.createProfile(userCredential, name);
    });
    if (state.hasError) {
      showFirebaseErrorSnack(context, state.error);
    } else {
      context.go(TutorialScreen.routeURL);
    }
  }
}

final signUpForm = StateProvider((ref) => {});

final signUpProvider = AsyncNotifierProvider<SignUpViewModel, void>(
  () => SignUpViewModel(),
);
