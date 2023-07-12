import 'package:din/authentication/repos/authentication_repo.dart';
import 'package:din/authentication/widgets/auth_social_button.dart';
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
              Gaps.v4,
              Text(
                'hsuj86@gmail.com',
                style: TextStyle(
                  color: Colors.grey.shade700,
                ),
              ),
              Gaps.v40,
              const AuthSocialButton(
                icon: FontAwesomeIcons.bullhorn,
                company: 'Notice',
              ),
              Gaps.v10,
              AuthSocialButton(
                icon: FontAwesomeIcons.toggleOn,
                company: 'Dark mode',
                onTap: _onLogoutTap,
              ),
              Gaps.v10,
              AuthSocialButton(
                icon: FontAwesomeIcons.arrowRightFromBracket,
                company: 'Log Out',
                onTap: _onLogoutTap,
              ),
              /* ListTile(
                minVerticalPadding: 30,
                leading: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      width: 1,
                      color: Colors.grey.shade200,
                    ),
                    // color: Colors.grey.shade200,
                  ),
                  child: const Center(
                    child: FaIcon(
                      FontAwesomeIcons.arrowRightFromBracket,
                      size: 16,
                    ),
                  ),
                ),
                title: const Text('Log out'),
                onTap: () {
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
                },
              ), */
              // const AboutListTile(),
            ],
          ),
        ),
      ),
    );
  }
}
