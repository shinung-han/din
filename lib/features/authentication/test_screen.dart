import 'package:din/features/authentication/sign_up_screen.dart';
import 'package:din/features/authentication/widgets/auth_bottom_app_bar.dart';
import 'package:din/features/authentication/widgets/auth_social_button.dart';
import 'package:din/constants/gaps.dart';
import 'package:din/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LogInScreen2 extends StatefulWidget {
  const LogInScreen2({super.key});

  @override
  State<LogInScreen2> createState() => _LogInScreen2State();
}

class _LogInScreen2State extends State<LogInScreen2> {
  void _onSignUpTap() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SignUpScreen(),
      ),
    );
  }

  void _onUseEmailLoginTap() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const UseEmailOrPasswordScreen(),
      ),
    );
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
              const LoginScreenHeader(),
              /* Stack(
                alignment: Alignment.center,
                children: [
                  Divider(
                    thickness: 0.5,
                    color: Colors.grey.shade400,
                  ),
                  Container(
                    width: 30,
                    height: 30,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Text(
                      'or',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey.shade400,
                      ),
                    ),
                  )
                ],
              ), */
              Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
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
                  const AuthSocialButton(
                    company: 'Continue with Facebook',
                    icon: FontAwesomeIcons.facebook,
                  ),
                ],
              ),
              const Spacer(),
              const Text(
                'By continuing, you agree to our Terms of Service and acknowledge that you have read our Privacy Policy to learn how we collect, use, and share your data.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
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

class LogInButton extends StatelessWidget {
  final bool disabled;
  final Function() onTap;
  final String buttonText;

  const LogInButton({
    required this.disabled,
    required this.onTap,
    required this.buttonText,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: FractionallySizedBox(
        widthFactor: 1,
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(Sizes.size14),
          decoration: BoxDecoration(
            border: Border.all(
              width: 0.5,
              color: Colors.grey.shade300,
            ),
            color: disabled ? Colors.black : Colors.white,
            borderRadius: BorderRadius.circular(Sizes.size3),
          ),
          child: Text(
            buttonText,
            style: TextStyle(
              color: disabled ? Colors.white : Colors.grey.shade300,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

class UseEmailOrPasswordScreen extends StatefulWidget {
  const UseEmailOrPasswordScreen({super.key});

  @override
  State<UseEmailOrPasswordScreen> createState() =>
      _UseEmailOrPasswordScreenState();
}

class _UseEmailOrPasswordScreenState extends State<UseEmailOrPasswordScreen> {
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
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SignUpScreen(),
            ),
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
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(title: const Text('')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            children: [
              const LoginScreenHeader(),
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
                            child: Container(
                              width: 20,
                              alignment: Alignment.center,
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
                    LogInButton(
                      disabled: _isButtonEnabled,
                      onTap: _onSubmit,
                      buttonText: 'Log In',
                    ),
                    Gaps.v14,
                    LogInButton(
                      disabled: true,
                      onTap: _onCancelTap,
                      buttonText: 'Cancel',
                    ),
                  ],
                ),
              ),
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

class LoginScreenHeader extends StatelessWidget {
  const LoginScreenHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Gaps.v80,
        Text(
          'Log In for DIN',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        Gaps.v10,
        Text(
          'Manage your account, check notifications, comment on videos, and more.',
          textAlign: TextAlign.center,
        ),
        Gaps.v80,
      ],
    );
  }
}
