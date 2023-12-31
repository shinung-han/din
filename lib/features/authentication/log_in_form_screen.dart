import 'package:din/common/widgets/submit_button.dart';
import 'package:din/constants/gaps.dart';
import 'package:din/constants/sizes.dart';
import 'package:din/features/authentication/reset_password_screen.dart';
import 'package:din/features/authentication/widgets/auth_header.dart';
import 'package:din/features/authentication/view_models/login_view_model.dart';
import 'package:din/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
      _isButtonEnabled = emailValid(_emailController.text) &&
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

  void _onSubmit() {
    ref.read(loginProvider.notifier).login(
          formData['email']!,
          formData['password']!,
          context,
        );
  }

  void _onForgotPasswordTap() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ResetPasswordScreen(),
      ),
    );
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
          child: CustomScrollView(
            slivers: [
              const SliverAppBar(),
              SliverPadding(
                padding: const EdgeInsets.all(Sizes.size20),
                sliver: SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      const AuthHeader(
                        title: '이메일로 로그인',
                        subTitle:
                            "다시 오신 것을 환영합니다!\n당신의 여정은 계속되고 있습니다.\n오늘도 더 나은 자신을 향해 함께 나아가요!",
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              cursorHeight: Sizes.size16,
                              autocorrect: false,
                              onFieldSubmitted: (value) {
                                FocusScope.of(context)
                                    .requestFocus(_passwordNode);
                              },
                              decoration: InputDecoration(
                                labelStyle:
                                    TextStyle(color: Colors.grey.shade400),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey.shade400)),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade400),
                                ),
                                suffix: Padding(
                                  padding: const EdgeInsets.only(
                                      right: Sizes.size10),
                                  child: GestureDetector(
                                    onTap: () => _onDeleteTap(_emailController),
                                    child: FaIcon(
                                      FontAwesomeIcons.xmark,
                                      size: Sizes.size18,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ),
                                labelText: '이메일',
                              ),
                            ),
                            Gaps.v16,
                            TextFormField(
                              controller: _passwordController,
                              focusNode: _passwordNode,
                              obscureText: _obscureText,
                              cursorHeight: Sizes.size16,
                              autocorrect: false,
                              onFieldSubmitted: (_) => _onSubmit(),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              decoration: InputDecoration(
                                labelStyle:
                                    TextStyle(color: Colors.grey.shade400),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey.shade400)),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade400),
                                ),
                                labelText: '비밀번호',
                                suffix: Padding(
                                  padding: const EdgeInsets.only(
                                      right: Sizes.size10),
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
                            ),
                            Gaps.v20,
                            GestureDetector(
                              onTap: _onForgotPasswordTap,
                              child: Text(
                                '비밀번호를 잊으셨나요?',
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
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          height: 90,
          child: SubmitButton(
            disabled: _isButtonEnabled,
            onTap: _onSubmit,
            buttonText: '로그인',
            icon: Icons.alternate_email_rounded,
          ),
        ),
      ),
    );
  }
}
