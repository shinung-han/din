import 'package:din/common/widgets/common_button.dart';
import 'package:din/features/authentication/repos/authentication_repo.dart';
import 'package:din/constants/gaps.dart';
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
  bool _isEdit = false;

  bool _isDarkMode = false;

  void _onDarkAndLightModeTap() {
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
              context.go('/');
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Profile',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _isEdit = !_isEdit;
                });
              },
              child: Container(
                width: 65,
                height: 36,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1,
                    color: Colors.grey.shade300,
                  ),
                  borderRadius: BorderRadius.circular(4),
                  color: _isEdit ? Colors.black : Colors.white,
                ),
                child: Center(
                  child: Text(
                    _isEdit ? 'Done' : 'Edit',
                    style: TextStyle(
                      color: _isEdit ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Gaps.v40,
              if (!_isEdit)
                const CircleAvatar(
                  radius: 70,
                  backgroundImage: AssetImage('assets/images/profile.jpeg'),
                ),
              if (_isEdit)
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 70,
                      backgroundColor: Colors.grey.shade400,
                      backgroundImage: const AssetImage(
                        'assets/images/profile.jpeg',
                      ),
                      // child: Text('신웅'),
                    ),
                    GestureDetector(
                      onTap: () {
                        print('change profile image');
                      },
                      child: CircleAvatar(
                        radius: 70,
                        backgroundColor: Colors.grey.shade400.withOpacity(0.8),
                        child: const Center(
                          child: FaIcon(
                            FontAwesomeIcons.camera,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              Gaps.v12,
              const Text(
                'Shinung Han',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'hsuj86@gmail.com',
                style: TextStyle(
                  color: Colors.grey.shade700,
                ),
              ),
              Gaps.v40,
              const CommonButton(
                icon: FontAwesomeIcons.bullhorn,
                text: 'Notice',
              ),
              Gaps.v10,
              CommonButton(
                icon: FontAwesomeIcons.toggleOff,
                text: _isDarkMode ? 'Dark Mode' : 'Light Mode',
                onTap: _onDarkAndLightModeTap,
              ),
              Gaps.v10,
              CommonButton(
                icon: FontAwesomeIcons.arrowRightFromBracket,
                text: 'Log Out',
                bgColor: Colors.redAccent,
                borderColor: Colors.redAccent,
                color: Colors.white,
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
