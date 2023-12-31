import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:din/common/widgets/common_button.dart';
import 'package:din/features/authentication/log_in_form_screen.dart';
import 'package:din/features/authentication/sign_up_form_screen.dart';
import 'package:din/constants/gaps.dart';
import 'package:din/features/onboarding/tutorial_screen.dart';
import 'package:din/features/users/view_models/users_view_model.dart';
import 'package:din/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';

enum LoginPlatform {
  google,
  none, // logout
}

class LoginScreen extends ConsumerStatefulWidget {
  static String routeURL = '/login';
  static String routeName = 'login';

  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  void _onUseEmailLoginTap() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LogInFormScreen(),
      ),
    );
  }

  void _onSignUpTap() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SignUpFormScreen(),
      ),
    );
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential authResult =
          await _firebaseAuth.signInWithCredential(credential);

      final name = authResult.user!.displayName;

      final String uid = authResult.user!.uid;
      final DocumentSnapshot userSnapshot =
          await _db.collection('users').doc(uid).get();

      final users = ref.read(usersProvider.notifier);

      if (!userSnapshot.exists) {
        await users.createProfile(authResult, name!);
        context.go(TutorialScreen.routeURL);
      } else {
        context.go('/home');
      }
    } catch (e) {
      showFirebaseErrorSnack(context, e);
    }

    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Gaps.v80,
                Gaps.v40,
                Image(
                  image: AssetImage("assets/images/logo.png"),
                  width: 150,
                ),
                Gaps.v28,
                Text(
                  "DIN",
                  style: TextStyle(
                    fontSize: 40,
                    // fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  "Do it now",
                  style: TextStyle(color: Colors.grey.shade400),
                ),
                Gaps.v80,
                CommonButton(
                  text: '이메일로 로그인',
                  icon: Icons.alternate_email_rounded,
                  onTap: _onUseEmailLoginTap,
                ),
                Gaps.v16,
                CommonButton(
                  text: "회원가입",
                  icon: Icons.login_rounded,
                  onTap: _onSignUpTap,
                ),
                Gaps.v16,
                CommonButton(
                  text: 'Google로 계속하기',
                  image: Image.asset('assets/images/google_logo.png'),
                  onTap: () => signInWithGoogle(context),
                ),
              ],
            ),
          ),
        ),
      ),
      // bottomNavigationBar: const BottomAppBar(
      //   child: Padding(
      //     padding: EdgeInsets.symmetric(
      //       horizontal: 20,
      //       // vertical: 20,
      //     ),
      //     child: Text(
      //       'By continuing, you agree to our Terms of Service and acknowledge that you have read our Privacy Policy to learn how we collect, use, and share your data.',
      //       textAlign: TextAlign.center,
      //       style: TextStyle(
      //         fontSize: 12,
      //       ),
      //     ),
      //   ),
      // ),
    );
  }
}
