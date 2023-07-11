import 'package:din/authentication/log_in_screen.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  void _onLogOutTap() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }

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
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('로그아웃 하시겠습니까?'),
                    // backgroundColor: Colors.teal,
                    // duration: const Duration(milliseconds: 1000),
                    behavior: SnackBarBehavior.floating,
                    action: SnackBarAction(
                      label: 'Undo',
                      textColor: Colors.white,
                      onPressed: () => print('Pressed'),
                    ),
                    shape: const RoundedRectangleBorder(
                        // borderRadius: BorderRadius.circular(20),
                        // side: const BorderSide(
                        //   color: Colors.red,
                        //   width: 2,
                        // ),
                        ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
