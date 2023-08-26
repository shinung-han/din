import 'dart:io';

import 'package:din/features/authentication/repos/authentication_repo.dart';
import 'package:din/features/users/model/user_profile_model.dart';
import 'package:din/features/users/repos/user_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UsersViewModel extends StateNotifier<UserProfileModel> {
  late final UserRepository _usersRepository;
  late final AuthenticationRepository _authenticationRepository;

  UsersViewModel(ref)
      : _usersRepository = ref.read(userRepo),
        _authenticationRepository = ref.read(authRepo),
        super(UserProfileModel.empty()) {
    listenToUserChanges();
  }

  Future<UserProfileModel> fetchUserProfile() async {
    if (_authenticationRepository.isLoggedIn) {
      final profile = await _usersRepository.findProfile(
        _authenticationRepository.user!.uid,
      );
      if (profile != null) {
        state = UserProfileModel.fromJson(profile);
        return state;
      }
    }
    return UserProfileModel.empty();
  }

  List<String> getLoginMethod(ref) {
    final user = ref.read(authRepo).user;
    List<String> methods = [];
    if (user != null) {
      for (UserInfo userInfo in user.providerData) {
        methods.add(userInfo.providerId);
      }
    }
    return methods;
  }

  void listenToUserChanges() {
    FirebaseAuth.instance.userChanges().listen((event) async {
      if (event == null) {
        state = UserProfileModel.empty();
        return;
      }

      final profile = await _usersRepository.findProfile(event.uid);
      if (profile != null) {
        state = UserProfileModel.fromJson(profile);
      } else {
        state = UserProfileModel.empty();
      }
    });
  }

  Future<void> createProfile(UserCredential credential, String name) async {
    if (credential.user == null) {
      throw Exception("Account not created");
    }
    final profile = UserProfileModel(
      bio: "undefined",
      link: "undefined",
      uid: credential.user!.uid,
      name: credential.user!.displayName ?? name,
      email: credential.user!.email ?? "anon@din.com",
      hasAvatar: false,
      avatarUrl: "",
      hasProject: false,
      isLoading: false,
      startDate: DateTime.now(),
    );
    await _usersRepository.createProfile(profile, name);
    state = profile;
  }

  Future<void> onAvatarUpload(File file, String oldFileName) async {
    final newAvatarUrl =
        await _usersRepository.uploadAvatar(file, oldFileName, state.uid);
    state = state.copyWith(hasAvatar: true, avatarUrl: newAvatarUrl);
    await _usersRepository.updateUser(
      state.uid,
      {
        "hasAvatar": true,
        "avatarUrl": newAvatarUrl,
      },
    );
  }

  Future<void> onEditUsername(String newName) async {
    // if (state == null) return;
    state = state.copyWith(name: newName);
    await _usersRepository.updateUser(state.uid, {"name": newName});
  }
}

final usersProvider = StateNotifierProvider<UsersViewModel, UserProfileModel>(
  (ref) => UsersViewModel(ref),
);
