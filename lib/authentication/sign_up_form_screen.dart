import 'package:din/authentication/log_in_screen.dart';
import 'package:din/authentication/widgets/auth_bottom_app_bar.dart';
import 'package:din/authentication/widgets/auth_social_button.dart';
import 'package:din/authentication/widgets/auth_header.dart';
import 'package:din/authentication/widgets/auth_submit_button.dart';
import 'package:din/constants/gaps.dart';
import 'package:din/constants/sizes.dart';
import 'package:din/utils.dart';
import 'package:din/authentication/view_models/signup_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class SignUpFormScreen extends ConsumerStatefulWidget {
  const SignUpFormScreen({super.key});

  @override
  ConsumerState<SignUpFormScreen> createState() => _SignUpFormScreenState();
}

class _SignUpFormScreenState extends ConsumerState<SignUpFormScreen> {
  void _onScaffoldTap() {
    FocusScope.of(context).unfocus();
  }

  late final TextEditingController _emailController = TextEditingController()
    ..addListener(() {
      setState(() {
        formData['email'] = _emailController.text;
      });
    });

  late final TextEditingController _passwordController = TextEditingController()
    ..addListener(() {
      setState(() {
        formData['password'] = _passwordController.text;
      });
    });

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Map<String, dynamic> formData = {};

  void _onLoginTap() {
    context.goNamed(LoginScreen.routeName);
  }

  bool obscureText = false;

  void _toggleObscureText() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  bool isErrorText = false;

  void _onSubmit() {
    ref.read(signUpProvider.notifier).signUp(context);
  }

  bool _isButtonEnabled = false;

  void _validateInputs() {
    if (_formKey.currentState != null) {
      if (_formKey.currentState!.validate()) {
        setState(() {
          _isButtonEnabled = true;
        });
      } else {
        setState(() {
          _isButtonEnabled = false;
        });
      }
    }

    ref.read(signUpForm.notifier).state = {
      'email': formData['email'],
      'password': formData['password'],
    };
  }

  void _onCancelTap() {
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onScaffoldTap,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const AuthHeader(
                    title: 'Sign Up for DIN',
                    subTitle:
                        'Create a profile, follow other accounts, make your own videos, and more.',
                  ),
                  Form(
                    key: _formKey,
                    onChanged: _validateInputs,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          cursorHeight: Sizes.size16,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                          ),
                          validator: (value) {
                            if (!emailValid(value)) {
                              return '이메일 형식을 확인해 주세요.';
                            }

                            return null;
                          },
                        ),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: obscureText,
                          cursorHeight: Sizes.size16,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            suffix: Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: GestureDetector(
                                onTap: _toggleObscureText,
                                child: FaIcon(
                                  obscureText
                                      ? FontAwesomeIcons.eye
                                      : FontAwesomeIcons.eyeSlash,
                                  size: 16,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value!.length < 6) {
                              return '6자 이상 입력해주세요!';
                            }
                            return null;
                          },
                        ),
                        if (!isErrorText) Gaps.v40,
                        if (isErrorText)
                          Container(
                            height: 40,
                            alignment: Alignment.center,
                            child: Text(
                              isErrorText ? '아이디 또는 비밀번호를 확인해 주세요' : '',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        AuthSubmitButton(
                          disabled: _isButtonEnabled,
                          onTap: _onSubmit,
                          buttonText: 'Sign Up',
                        ),
                        Gaps.v14,
                        AuthSocialButton(
                          company: 'Cancel',
                          onTap: _onCancelTap,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: AuthBottomAppBar(
          tapText: 'Log In',
          onTap: _onLoginTap,
        ),
      ),
    );
  }
}
