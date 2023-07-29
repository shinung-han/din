import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:din/common/widgets/common_button.dart';
import 'package:din/features/authentication/log_in_form_screen.dart';
import 'package:din/features/authentication/sign_up_form_screen.dart';
import 'package:din/features/authentication/widgets/auth_policy.dart';
import 'package:din/constants/gaps.dart';
import 'package:din/features/onboarding/tutorial_screen.dart';
import 'package:din/features/users/view_models/users_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';

enum LoginPlatform {
  facebook,
  google,
  kakao,
  naver,
  apple,
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

  Future<void> signInWithGoogle() async {
    // GoogleSignIn googleSignIn = GoogleSignIn();
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
      print('Google 로그인 에러: $e');
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
                /* const AuthHeader(
                  title: 'Log In for DIN',
                  subTitle:
                      'Manage your account, check notifications, comment on videos, and more.',
                ),
                 */
                Gaps.v80,
                Gaps.v60,
                const Text(
                  'DIN',
                  style: TextStyle(
                    fontSize: 80,
                  ),
                ),
                Gaps.v80,
                Gaps.v60,
                CommonButton(
                  text: 'Log In',
                  icon: FontAwesomeIcons.user,
                  onTap: _onUseEmailLoginTap,
                ),

                Gaps.v16,
                CommonButton(
                  text: "Sign Up",
                  icon: FontAwesomeIcons.francSign,
                  onTap: _onSignUpTap,
                ),
                Gaps.v16,
                CommonButton(
                  text: 'Continue with Google',
                  // icon: FontAwesomeIcons.google,
                  image: Image.asset('assets/images/google_logo.png'),
                  onTap: signInWithGoogle,
                ),
                // Gaps.v16,
                // Gaps.v20,
                // const AuthPolicy(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const BottomAppBar(
        child: AuthPolicy(),
      ),
      /* bottomNavigationBar: AuthBottomAppBar(
        text: "Are you not a member yet?",
        tapText: 'Sign Up',
        onTap: _onSignUpTap,
      ), */
    );
  }
}
