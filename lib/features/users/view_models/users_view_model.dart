import 'dart:async';

import 'package:din/features/authentication/repos/authentication_repo.dart';
import 'package:din/features/users/model/user_profile_model.dart';
import 'package:din/features/users/repos/user_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UsersViewModel extends AsyncNotifier<UserProfileModel> {
  late final UserRepository _usersRepository;
  late final AuthenticationRepository _authenticationRepository;

  Future<UserProfileModel> fetchUserProfile() async {
    _usersRepository = ref.read(userRepo);
    _authenticationRepository = ref.read(authRepo);

    if (_authenticationRepository.isLoggedIn) {
      final profile = await _usersRepository.findProfile(
        _authenticationRepository.user!.uid,
      );
      if (profile != null) {
        return UserProfileModel.fromJson(profile);
      }
    }

    return UserProfileModel.empty();
  }

  void listenToUserChanges() {
    FirebaseAuth.instance.userChanges().listen((event) async {
      if (event == null) {
        state = AsyncValue.data(UserProfileModel.empty());
        return;
      }

      final profile = await _usersRepository.findProfile(event.uid);
      if (profile != null) {
        state = AsyncValue.data(UserProfileModel.fromJson(profile));
      } else {
        state = AsyncValue.data(UserProfileModel.empty());
      }
    });
  }

  @override
  FutureOr<UserProfileModel> build() async {
    await fetchUserProfile();
    listenToUserChanges();
    return state.value!;
  }

  Future<void> createProfile(UserCredential credential, String name) async {
    if (credential.user == null) {
      throw Exception("Account not created");
    }
    state = const AsyncValue.loading();
    final profile = UserProfileModel(
      hasAvatar: false,
      bio: "undefined",
      link: "undefined",
      uid: credential.user!.uid,
      name: credential.user!.displayName ?? name,
      email: credential.user!.email ?? "anon@din.com",
    );
    await _usersRepository.createProfile(profile, name);
    state = AsyncValue.data(profile);
  }

  Future<void> onAvatarUpload() async {
    if (state.value == null) return;
    state = AsyncValue.data(state.value!.copyWith(hasAvatar: true));
    await _usersRepository.updateUser(state.value!.uid, {"hasAvatar": true});
  }
}

final usersProvider = AsyncNotifierProvider<UsersViewModel, UserProfileModel>(
  () => UsersViewModel(),
);
