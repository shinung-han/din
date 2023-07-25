import 'dart:convert';
import 'dart:io';

import 'package:din/common/widgets/common_button.dart';
import 'package:din/features/authentication/log_in_form_screen.dart';
import 'package:din/features/authentication/sign_up_screen.dart';
import 'package:din/features/authentication/widgets/auth_bottom_app_bar.dart';
import 'package:din/features/authentication/widgets/auth_header.dart';
import 'package:din/features/authentication/widgets/auth_policy.dart';
import 'package:din/constants/gaps.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:http/http.dart' as http;

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
    context.go(SignUpScreen.routeURL);
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> signInWithGoogle() async {
    GoogleSignIn googleSignIn = GoogleSignIn();
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
      // final User? user = authResult.user;

      // if (user != null) {
      //   return User(
      //       id: user.uid,
      //       name: user.displayName ?? '',
      //       email: user.email ?? '');
      // }
      context.go('/home');
    } catch (e) {
      print('Google 로그인 에러: $e');
    }

    return;
  }

  final LoginPlatform _loginPlatform = LoginPlatform.none;

  Future<void> _onKakaoLogin() async {
    print(await KakaoSdk.origin);
    try {
      bool isInstalled = await isKakaoTalkInstalled();

      OAuthToken token = isInstalled
          ? await UserApi.instance.loginWithKakaoTalk()
          : await UserApi.instance.loginWithKakaoAccount();

      final url = Uri.https('kapi.kakao.com', '/v2/user/me');

      final response = await http.get(
        url,
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer ${token.accessToken}'
        },
      );

      final profileInfo = json.decode(response.body);
      print(profileInfo.toString());

      // setState(() {
      //   _loginPlatform = LoginPlatform.kakao;
      // });
    } catch (error) {
      print('카카오톡으로 로그인 실패 $error');
    }
  }

  Future<void> _onNaverLoginTap() async {
    final NaverLoginResult result = await FlutterNaverLogin.logIn();

    if (result.status == NaverLoginStatus.loggedIn) {
      print('accessToken = ${result.accessToken}');
      print('id = ${result.account.id}');
      print('email = ${result.account.email}');
      print('name = ${result.account.name}');

      // setState(() {
      //   _loginPlatform = LoginPlatform.naver;
      // });
    } else {
      print(result.errorMessage);
    }
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
                const AuthHeader(
                  title: 'Log In for DIN',
                  subTitle:
                      'Manage your account, check notifications, comment on videos, and more.',
                ),
                CommonButton(
                  text: 'Use Email and Password',
                  icon: FontAwesomeIcons.user,
                  onTap: _onUseEmailLoginTap,
                ),
                Gaps.v10,
                CommonButton(
                  text: 'Continue with Google',
                  icon: FontAwesomeIcons.google,
                  onTap: signInWithGoogle,
                ),
                Gaps.v10,
                CommonButton(
                  text: 'Continue with Kakao',
                  icon: FontAwesomeIcons.apple,
                  onTap: _onKakaoLogin,
                ),
                Gaps.v10,
                CommonButton(
                  text: 'Continue with Naver',
                  icon: FontAwesomeIcons.facebook,
                  onTap: _onNaverLoginTap,
                ),
                Gaps.v120,
                const AuthPolicy(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: AuthBottomAppBar(
        text: "Are you not a member yet?",
        tapText: 'Sign Up',
        onTap: _onSignUpTap,
      ),
    );
  }
}
