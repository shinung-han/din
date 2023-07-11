import 'package:din/authentication/log_in_screen.dart';
import 'package:din/authentication/widgets/auth_bottom_app_bar.dart';
import 'package:din/authentication/widgets/auth_button.dart';
import 'package:din/authentication/widgets/auth_header.dart';
import 'package:din/authentication/widgets/auth_submit_button.dart';
import 'package:din/constants/gaps.dart';
import 'package:din/constants/sizes.dart';
import 'package:din/view_models/signup_view_model.dart';
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
  late final TextEditingController emailController = TextEditingController()
    ..addListener(() {
      setState(() {
        formData['email'] = emailController.text;
      });
    });

  late final TextEditingController passwordController = TextEditingController()
    ..addListener(() {
      setState(() {
        formData['password'] = passwordController.text;
      });
    });

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Map<String, String> formData = {};

  void _onLoginTap() {
    context.goNamed(LoginScreen.routeName);
  }

  bool obscureText = true;

  void _toggleObscureText() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  bool isErrorText = false;

  void _onSubmit() {
    if (formKey.currentState != null) {
      if (formKey.currentState!.validate()) {
        ref.read(signUpForm.notifier).state = {
          'email': formData['email'],
          'password': formData['password']
        } as Null;
        print(ref.read(signUpForm));
        // if (formData['email'] == 'hsuj86@gmail.com' &&
        //     formData['password'] == '12345') {
        //   formKey.currentState!.save();
        //   Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => const SignUpScreen(),
        //     ),
        //   );
        // } else {
        //   setState(() {
        //     isErrorText = true;
        //   });
        // }
      }
    }
  }

  bool isButtonEnabled = false;

  void _validateInputs() {
    if (formData['email']!.isNotEmpty && formData['password'] != null) {
      if (formData['password']!.length > 4) {
        setState(() {
          isButtonEnabled = true;
        });
      } else {
        setState(() {
          isButtonEnabled = false;
        });
      }
    }
  }

  void _onCancelTap() {
    // FocusScope.of(context).unfocus();
    // const Duration(milliseconds: 50);
    Navigator.pop(context);
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _onScaffoldTap() {
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onScaffoldTap,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const AuthHeader(
                    title: 'Sign Up for DIN',
                    subTitle:
                        'Create a profile, follow other accounts, make your own videos, and more.',
                  ),
                  Form(
                    key: formKey,
                    onChanged: _validateInputs,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          cursorHeight: Sizes.size16,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                          ),
                          validator: (value) {
                            if (value != null && value.length < 5) {
                              // return 'Please write your email';
                              return null;
                            } else if (value!.isEmpty) {
                              return '';
                            }
                            return null;
                          },
                          onSaved: (newValue) {
                            if (newValue != null) {
                              formData['email'] = newValue;
                            }
                          },
                        ),
                        TextFormField(
                          controller: passwordController,
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
                            if (value!.length < 5) {
                              // return 'Please enter your password';
                              return null;
                            }
                            return null;
                          },
                          onSaved: (value) {
                            if (value != null) {
                              formData['password'] = value;
                            }
                          },
                        ),
                        /* TextFormField(
                          controller: passwordController,
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
                            if (value!.length < 5) {
                              // return 'Please enter your password';
                              return null;
                            }
                            return null;
                          },
                          onSaved: (value) {
                            if (value != null) {
                              formData['password'] = value;
                            }
                          },
                        ), */
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
                        // if (_isErrorText)
                        //   const
                        // const SizedBox(height: 14),
                        AuthSubmitButton(
                          disabled: isButtonEnabled,
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
