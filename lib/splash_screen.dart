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

    _firebaseAuth.authStateChanges().listen((user) async {
      if (user != null) {
        await Future.delayed(
          const Duration(
            seconds: 5,
          ),
        );
        context.go(LoginScreen.routeURL);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'DIN',
              style: TextStyle(fontSize: 80, fontWeight: FontWeight.bold),
            ),
            Gaps.v40,
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
