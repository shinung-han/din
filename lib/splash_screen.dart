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
        // TODO 기능 구현 다 하면 dealyed 지워야함
        await Future.delayed(
          const Duration(
            seconds: 5,
          ),
        );

        // [ ] 불필요한 코드일 수 있음. 아래의 context에서 오류가 나서 넣어놓은 것
        if (!mounted) return;

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
