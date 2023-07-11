import 'package:din/repos/authentication_repo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SafeArea(
        child: Column(
          children: [
            ListTile(
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
            ),
            const AboutListTile(),
          ],
        ),
      ),
    );
  }
}
