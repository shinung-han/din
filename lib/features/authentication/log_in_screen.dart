import 'package:din/features/authentication/log_in_form_screen.dart';
import 'package:din/features/authentication/sign_up_screen.dart';
import 'package:din/features/authentication/widgets/auth_bottom_app_bar.dart';
import 'package:din/features/authentication/widgets/auth_header.dart';
import 'package:din/features/authentication/widgets/auth_policy.dart';
import 'package:din/features/authentication/widgets/auth_social_button.dart';
import 'package:din/constants/gaps.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  static String routeURL = '/';
  static String routeName = 'login';

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  void _onUseEmailLoginTap() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LogInFormScreen(),
      ),
    );
  }

  void _onSignUpTap() {
    context.pushNamed(SignUpScreen.routeName);
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
                AuthSocialButton(
                  company: '이메일과 비밀번호 사용하기',
                  icon: FontAwesomeIcons.user,
                  onTap: _onUseEmailLoginTap,
                ),
                Gaps.v10,
                const AuthSocialButton(
                  company: 'Google로 시작하기',
                  icon: FontAwesomeIcons.google,
                ),
                Gaps.v10,
                const AuthSocialButton(
                  company: 'Apple로 시작하기',
                  icon: FontAwesomeIcons.apple,
                ),
                Gaps.v10,
                const AuthSocialButton(
                  company: 'Facebook으로 시작하기',
                  icon: FontAwesomeIcons.facebook,
                ),
                // const Spacer(),
                Gaps.v120,
                const AuthPolicy(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: AuthBottomAppBar(
        tapText: '회원가입',
        onTap: _onSignUpTap,
      ),
    );
  }
}
