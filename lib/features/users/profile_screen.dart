import 'package:din/change_password_screen.dart';
import 'package:din/common/widgets/common_button.dart';
import 'package:din/features/authentication/repos/authentication_repo.dart';
import 'package:din/constants/gaps.dart';
import 'package:din/splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

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

  @override
  Widget build(BuildContext context) {
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
                  const CircleAvatar(
                    radius: 70,
                    backgroundImage: AssetImage('assets/images/profile.jpeg'),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      // TODO 프로필 이미지 변경
                      onTap: () {
                        print('프로필 이미지 변경 로직');
                      },
                      child: CircleAvatar(
                        radius: 22,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.grey.shade400,
                          child: const Center(
                            child: FaIcon(
                              FontAwesomeIcons.camera,
                              size: 18,
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
              const Text(
                'hsuj86@gmail.com',
                style: TextStyle(
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
  }
}
