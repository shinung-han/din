import 'dart:io';

import 'package:din/change_password_screen.dart';
import 'package:din/common/widgets/common_button.dart';
import 'package:din/features/authentication/repos/authentication_repo.dart';
import 'package:din/constants/gaps.dart';
import 'package:din/features/users/view_models/avatar_view_model.dart';
import 'package:din/features/users/view_models/users_view_model.dart';
import 'package:din/features/users/widgets/avatar.dart';
import 'package:din/splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final bool _isEdit = false;

  bool _isDarkMode = false;

  void _onModeTap() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  void _onLogoutTap() {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Are you sure?'),
        // content: const Text("Please dont go"),
        actions: [
          CupertinoDialogAction(
            child: const Text(
              'No',
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: const Text(
              'Yes',
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            onPressed: () {
              ref.read(authRepo).signOut();
              // TODO LoginScreen으로 경로 수정해야함
              // [ ] 되는지 테스트해보기
              // context.go(LoginScreen.routeURL);
              context.go(SplashScreen.routeURL);
            },
          ),
        ],
      ),
    );
  }

  void _onChangePasswordTap() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ChangePasswordScreen(),
      ),
    );
  }

  Future<void> _onChangeProfileImage() async {
    final xFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 100,
      maxHeight: 200,
      maxWidth: 200,
      // 수정 전 : imageQuality : 50, maxHeight & maxWidth : 150
    );
    if (xFile != null) {
      final file = File(xFile.path);
      ref.read(avatarProvider.notifier).uploadAvatar(file);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(usersProvider).when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => Center(child: Text(error.toString())),
          data: (data) {
            final isLoading = ref.watch(avatarProvider).isLoading;

            return Scaffold(
              appBar: AppBar(
                // backgroundColor: Colors.white,
                title: const Text(
                  'Profile',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                /* actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: _onModeTap,
              icon: Icon(
                _isDarkMode ? Icons.dark_mode_sharp : Icons.sunny,
              ),
            ),
          ),
        ], */
              ),
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Gaps.v40,
                      Stack(
                        children: [
                          isLoading
                              ? Container(
                                  width: 140,
                                  height: 140,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      width: 1,
                                      color: Colors.grey.shade200,
                                    ),
                                    color: Colors.grey.shade200,
                                  ),
                                  child: const CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                )
                              : Avatar(
                                  name: data.name,
                                  hasAvatar: data.hasAvatar,
                                  uid: data.uid,
                                ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: isLoading ? null : _onChangeProfileImage,
                              child: CircleAvatar(
                                radius: 20,
                                backgroundColor: Colors.white,
                                child: CircleAvatar(
                                  radius: 16,
                                  backgroundColor: Colors.grey.shade400,
                                  child: const Center(
                                    child: FaIcon(
                                      FontAwesomeIcons.image,
                                      size: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Gaps.v20,
                      Text(
                        data.email,
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      Gaps.v20,
                      Text(
                        data.name,
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      Gaps.v20,
                      const Divider(
                        thickness: 0.5,
                        color: Colors.grey,
                      ),
                      Gaps.v20,
                      CommonButton(
                        icon: FontAwesomeIcons.lockOpen,
                        text: 'Change Password',
                        onTap: _onChangePasswordTap,
                      ),
                      Gaps.v10,
                      CommonButton(
                        icon: _isDarkMode ? Icons.dark_mode_sharp : Icons.sunny,
                        text: _isDarkMode ? 'To Dark Mode' : 'To Light Mode',
                        onTap: _onModeTap,
                      ),
                      Gaps.v10,
                      CommonButton(
                        icon: FontAwesomeIcons.arrowRightFromBracket,
                        text: 'Log Out',
                        // bgColor: Colors.black,
                        // color: Colors.white,
                        // bgColor: Colors.redAccent,
                        // borderColor: Colors.redAccent,
                        onTap: _onLogoutTap,
                      ),
                      // const AboutListTile(),
                    ],
                  ),
                ),
              ),
            );
          },
        );
  }
}
