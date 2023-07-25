import 'package:din/constants/gaps.dart';
import 'package:din/features/authentication/log_in_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends ConsumerStatefulWidget {
  static String routeURL = '/';
  static String routeName = 'splash';

  const SplashScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();

    _firebaseAuth.authStateChanges().listen((user) {
      if (user != null) {
        if (!mounted) return;
        context.go('/home');
      } else {
        if (!mounted) return;
        context.go(LoginScreen.routeURL);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color(0xff0352BE),
      backgroundColor: const Color(0xffF6D702),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                'DIN',
                style: TextStyle(
                  fontSize: 120,
                  fontWeight: FontWeight.bold,
                  // color: Colors.white,
                  // color: Colors.black,
                  color: Color(0xff003A8C),
                ),
              ),
            ),
            Gaps.v40,
            CircularProgressIndicator(
              color: Colors.white,
              // color: Color(0xffEEE201),
            ),
          ],
        ),
      ),
    );
  }
}
