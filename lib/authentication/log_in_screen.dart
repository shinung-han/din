import 'package:din/authentication/log_in_form_screen.dart';
import 'package:din/authentication/sign_up_screen.dart';
import 'package:din/authentication/widgets/auth_bottom_app_bar.dart';
import 'package:din/authentication/widgets/auth_button.dart';
import 'package:din/authentication/widgets/auth_header.dart';
import 'package:din/authentication/widgets/auth_policy.dart';
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

  void _onGoHomeTap() {
    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            children: [
              const AuthHeader(
                title: 'Log In for DIN',
                subTitle:
                    'Manage your account, check notifications, comment on videos, and more.',
              ),
              AuthSocialButton(
                company: 'Use Email and Password',
                icon: FontAwesomeIcons.user,
                onTap: _onUseEmailLoginTap,
              ),
              Gaps.v14,
              const AuthSocialButton(
                company: 'Continue with Google',
                icon: FontAwesomeIcons.google,
              ),
              Gaps.v14,
              GestureDetector(
                onTap: _onGoHomeTap,
                child: const AuthSocialButton(
                  company: 'Continue with Facebook',
                  icon: FontAwesomeIcons.facebook,
                ),
              ),
              const Spacer(),
              const AuthPolicy(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AuthBottomAppBar(
        tapText: 'Sign Up',
        onTap: _onSignUpTap,
      ),
    );
  }
}

// class LogInButton extends StatelessWidget {
//   final bool disabled;
//   final Function() onTap;

//   const LogInButton({
//     super.key,
//     required this.disabled,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: FractionallySizedBox(
//         widthFactor: 1,
//         child: Container(
//           alignment: Alignment.center,
//           padding: const EdgeInsets.all(Sizes.size14),
//           decoration: BoxDecoration(
//             border: Border.all(
//               width: 0.5,
//               color: Colors.grey.shade300,
//             ),
//             color: disabled ? Colors.black : Colors.white,
//             borderRadius: BorderRadius.circular(Sizes.size3),
//           ),
//           child: Text(
//             'Log In',
//             style: TextStyle(
//               color: disabled ? Colors.white : Colors.grey.shade300,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
