import 'package:din/features/authentication/sign_up_form_screen.dart';
import 'package:din/features/authentication/widgets/auth_bottom_app_bar.dart';
import 'package:din/features/authentication/widgets/auth_social_button.dart';
import 'package:din/features/authentication/widgets/auth_header.dart';
import 'package:din/features/authentication/widgets/auth_policy.dart';
import 'package:din/constants/gaps.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class SignUpScreen extends StatefulWidget {
  static const routeName = 'signup';
  static const routeURL = '/signup';

  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  void _onUseEmailLoginTap() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SignUpFormScreen(),
      ),
    );
  }

  void _onLoginTap() {
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const AuthHeader(
                title: 'Sign Up for DIN',
                subTitle:
                    'Create a profile, follow other accounts, make your own videos, and more.',
              ),
              AuthSocialButton(
                company: 'Use email & password',
                icon: FontAwesomeIcons.user,
                onTap: _onUseEmailLoginTap,
              ),
              Gaps.v10,
              const AuthSocialButton(
                company: 'Continue with Google',
                icon: FontAwesomeIcons.google,
              ),
              Gaps.v10,
              const AuthSocialButton(
                company: 'Continue with Apple',
                icon: FontAwesomeIcons.apple,
              ),
              Gaps.v10,
              const AuthSocialButton(
                company: 'Continue with Facebook',
                icon: FontAwesomeIcons.facebook,
              ),
              const Spacer(),
              const AuthPolicy(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AuthBottomAppBar(
        tapText: 'Log In',
        onTap: _onLoginTap,
      ),
    );
  }
}
