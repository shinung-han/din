import 'package:din/authentication/sign_up_screen.dart';
import 'package:din/authentication/widgets/auth_bottom_app_bar.dart';
import 'package:din/authentication/widgets/auth_button.dart';
import 'package:din/authentication/widgets/auth_header.dart';
import 'package:din/authentication/widgets/auth_submit_button.dart';
import 'package:din/common/widgets/main_navigation_screen.dart';
import 'package:din/constants/gaps.dart';
import 'package:din/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LogInFormScreen extends StatefulWidget {
  // static String routename = 'loginform';
  // static String routeURL = 'loginform';

  const LogInFormScreen({super.key});

  @override
  State<LogInFormScreen> createState() => _LogInFormScreenState();
}

class _LogInFormScreenState extends State<LogInFormScreen> {
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

  Map<String, String> formData = {};

  void _onSignUpTap() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SignUpScreen(),
      ),
    );
  }

  bool _obscureText = true;

  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  bool _isErrorText = false;

  void _onSubmit() {
    if (_formKey.currentState != null) {
      if (_formKey.currentState!.validate()) {
        if (formData['email'] == 'hsuj86@gmail.com' &&
            formData['password'] == '12345') {
          _formKey.currentState!.save();
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const MainNavigationScreen(),
            ),
            (route) => false,
          );
        } else {
          setState(() {
            _isErrorText = true;
          });
        }
      }
    }
  }

  bool _isButtonEnabled = false;

  void _validateInputs() {
    if (formData['email']!.isNotEmpty && formData['password'] != null) {
      if (formData['password']!.length > 4) {
        setState(() {
          _isButtonEnabled = true;
        });
      } else {
        setState(() {
          _isButtonEnabled = false;
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
    _emailController.dispose();
    _passwordController.dispose();
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
                    title: 'Log In for DIN',
                    subTitle:
                        'Manage your account, check notifications, comment on videos, and more.',
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
                          controller: _passwordController,
                          obscureText: _obscureText,
                          cursorHeight: Sizes.size16,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            suffix: Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: GestureDetector(
                                onTap: _toggleObscureText,
                                child: FaIcon(
                                  _obscureText
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
                        if (!_isErrorText) Gaps.v40,
                        if (_isErrorText)
                          Container(
                            height: 40,
                            alignment: Alignment.center,
                            child: Text(
                              _isErrorText ? '아이디 또는 비밀번호를 확인해 주세요' : '',
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
                          disabled: _isButtonEnabled,
                          onTap: _onSubmit,
                          buttonText: 'Log In',
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
          tapText: 'Sign Up',
          onTap: _onSignUpTap,
        ),
      ),
    );
  }
}
