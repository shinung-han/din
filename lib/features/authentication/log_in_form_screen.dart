import 'package:din/common/widgets/common_button.dart';
import 'package:din/features/authentication/sign_up_screen.dart';
import 'package:din/features/authentication/widgets/auth_bottom_app_bar.dart';
import 'package:din/features/authentication/widgets/auth_header.dart';
import 'package:din/features/authentication/widgets/auth_submit_button.dart';
import 'package:din/constants/gaps.dart';
import 'package:din/constants/sizes.dart';
import 'package:din/features/authentication/view_models/login_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class LogInFormScreen extends ConsumerStatefulWidget {
  const LogInFormScreen({super.key});

  @override
  ConsumerState<LogInFormScreen> createState() => _LogInFormScreenState();
}

class _LogInFormScreenState extends ConsumerState<LogInFormScreen> {
  void _onScaffoldTap() {
    FocusScope.of(context).unfocus();
  }

  late final TextEditingController _emailController = TextEditingController()
    ..addListener(() {
      updateButtonState();
      setState(() {
        formData['email'] = _emailController.text;
      });
    });

  late final TextEditingController _passwordController = TextEditingController()
    ..addListener(() {
      updateButtonState();
      setState(() {
        formData['password'] = _passwordController.text;
      });
    });

  final FocusNode _passwordNode = FocusNode();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Map<String, String> formData = {};

  void _onDeleteTap(controller) {
    if (controller == _emailController) {
      setState(() {
        _emailController.clear();
      });
    } else {
      setState(() {
        _passwordController.clear();
      });
    }
  }

  void updateButtonState() {
    setState(() {
      _isButtonEnabled = _emailController.text.isNotEmpty &&
          _passwordController.text.length > 6;
    });
  }

  bool _isButtonEnabled = false;

  bool _obscureText = false;

  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  // final bool _isErrorText = false;

  void _onSubmit() {
    ref.read(loginProvider.notifier).login(
          formData['email']!,
          formData['password']!,
          context,
        );
  }

  // void _validateInputs() {
  //   if (_formKey.currentState != null) {
  //     if (_formKey.currentState!.validate()) {
  //       setState(() {
  //         _isButtonEnabled = true;
  //       });
  //     } else {
  //       setState(() {
  //         _isButtonEnabled = false;
  //       });
  //     }
  //   }
  // }

  void _onForgotPasswordTap() {
    print('Password 잃어버려쪄염');
  }

  void _onCancelTap() {
    Navigator.pop(context);
  }

  void _onSignUpTap() {
    context.go(SignUpScreen.routeURL);
  }

  // [ ] 오류 message들 쉽게 변경
  // [ ] Header 문구 변경

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
                    title: 'Log In for DIN',
                    subTitle:
                        'Manage your account, check notifications, comment on videos, and more.',
                  ),
                  Form(
                    key: _formKey,
                    // onChanged: _validateInputs,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          cursorHeight: Sizes.size16,
                          onFieldSubmitted: (value) {
                            FocusScope.of(context).requestFocus(_passwordNode);
                          },
                          decoration: InputDecoration(
                            labelStyle: const TextStyle(color: Colors.grey),
                            focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey)),
                            suffix: Padding(
                              padding:
                                  const EdgeInsets.only(right: Sizes.size10),
                              child: GestureDetector(
                                onTap: () => _onDeleteTap(_emailController),
                                child: FaIcon(
                                  FontAwesomeIcons.xmark,
                                  size: Sizes.size18,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ),
                            labelText: 'Email',
                          ),
                          /* validator: (value) {
                            if (!emailValid(value)) {
                              return '이메일 형식을 확인해 주세요.';
                            }

                            return null;
                          }, */
                        ),
                        TextFormField(
                          controller: _passwordController,
                          focusNode: _passwordNode,
                          obscureText: _obscureText,
                          cursorHeight: Sizes.size16,
                          onFieldSubmitted: (_) => _onSubmit(),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                            labelStyle: const TextStyle(color: Colors.grey),
                            focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey)),
                            labelText: 'Password',
                            suffix: Padding(
                              padding:
                                  const EdgeInsets.only(right: Sizes.size10),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  GestureDetector(
                                    onTap: _toggleObscureText,
                                    child: FaIcon(
                                      _obscureText
                                          ? FontAwesomeIcons.eye
                                          : FontAwesomeIcons.eyeSlash,
                                      size: Sizes.size18,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  Gaps.h12,
                                  GestureDetector(
                                    onTap: () =>
                                        _onDeleteTap(_passwordController),
                                    child: FaIcon(
                                      FontAwesomeIcons.xmark,
                                      size: Sizes.size18,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          validator: (value) {
                            // if (value!.length < 6) {
                            //   return '6자 이상 입력해주세요!';
                            // }
                            return null;
                          },
                        ),
                        Gaps.v40,
                        // [ ] 에러 메시지 넣을 공간이었음 확인 후  삭제 예정
                        // if (_isErrorText)
                        //   Container(
                        //     height: 40,
                        //     alignment: Alignment.center,
                        //     child: Text(
                        //       _isErrorText ? '아이디 또는 비밀번호를 확인해 주세요' : '',
                        //       style: const TextStyle(
                        //         fontSize: 12,
                        //         color: Colors.red,
                        //       ),
                        //     ),
                        //   ),
                        // if (_isErrorText)
                        //   const
                        // const SizedBox(height: 14),
                        AuthSubmitButton(
                          disabled: _isButtonEnabled,
                          // disabled: ref.watch(loginProvider).isLoading,
                          onTap: _onSubmit,
                          buttonText: 'Log In',
                        ),
                        Gaps.v14,
                        CommonButton(
                          text: 'Cancel',
                          onTap: _onCancelTap,
                        ),
                        Gaps.v14,
                        GestureDetector(
                          // TODO 비밀번호 찾기 로직
                          onTap: _onForgotPasswordTap,
                          child: Text(
                            'Forgot your Password?',
                            style: TextStyle(
                              color: Colors.grey.shade700,
                            ),
                          ),
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
