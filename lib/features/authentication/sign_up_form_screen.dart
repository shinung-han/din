import 'package:din/common/widgets/submit_button.dart';
import 'package:din/constants/gaps.dart';
import 'package:din/features/authentication/widgets/auth_header.dart';
import 'package:din/constants/sizes.dart';
import 'package:din/features/authentication/view_models/signup_view_model.dart';
import 'package:din/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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

  late final TextEditingController _nameController = TextEditingController()
    ..addListener(() {
      updateButtonState();
      setState(() {
        formData['name'] = _nameController.text;
      });
    });

  final FocusNode _passwordNode = FocusNode();
  final FocusNode _nameNode = FocusNode();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Map<String, dynamic> formData = {};

  bool _obscureText = false;

  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  bool isErrorText = false;

  void _onSubmit() {
    ref.read(signUpProvider.notifier).signUp(
          formData['email'],
          formData['password'],
          formData['name'],
          context,
        );
  }

  void _onDeleteTap(controller) {
    if (controller == _emailController) {
      setState(() {
        _emailController.clear();
      });
    } else if (controller == _passwordController) {
      setState(() {
        _passwordController.clear();
      });
    } else {
      setState(() {
        _nameController.clear();
      });
    }
  }

  void updateButtonState() {
    setState(() {
      _isButtonEnabled = emailValid(_emailController.text) &&
          _passwordController.text.length > 6 &&
          _nameController.text.length > 1;
    });
  }

  bool _isButtonEnabled = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
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
                padding: const EdgeInsets.all(20.0),
                sliver: SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      const AuthHeader(
                        title: '회원가입',
                        subTitle:
                            '환영합니다! 여기서 시작된 모든 노력은\n더 나은 내일의 당신을 만들어갑니다.\n매일매일의 변화를 믿고 함께 나아가요!',
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                                labelText: '이메일',
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
                              ),
                            ),
                            Gaps.v16,
                            TextFormField(
                              controller: _passwordController,
                              focusNode: _passwordNode,
                              obscureText: _obscureText,
                              cursorHeight: Sizes.size16,
                              onFieldSubmitted: (value) {
                                FocusScope.of(context).requestFocus(_nameNode);
                              },
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
                            Padding(
                              padding: const EdgeInsets.only(
                                top: Sizes.size4,
                                left: 1,
                              ),
                              child: Text(
                                "비밀번호는 최소 6자리 이상 입력해 주세요",
                                style: TextStyle(
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ),
                            Gaps.v16,
                            TextFormField(
                              controller: _nameController,
                              focusNode: _nameNode,
                              cursorHeight: Sizes.size16,
                              maxLength: 16,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              decoration: InputDecoration(
                                counterText: '',
                                labelStyle:
                                    TextStyle(color: Colors.grey.shade400),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey.shade400)),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade400),
                                ),
                                labelText: '이름',
                                suffix: Padding(
                                  padding: const EdgeInsets.only(
                                      right: Sizes.size10),
                                  child: GestureDetector(
                                    onTap: () => _onDeleteTap(_nameController),
                                    child: FaIcon(
                                      FontAwesomeIcons.xmark,
                                      size: Sizes.size18,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: Sizes.size4,
                                left: 1,
                              ),
                              child: Text(
                                "이름은 최소 2자리에서 최대 16자리까지 입력해 주세요",
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
            buttonText: '회원가입',
            icon: Icons.login_rounded,
          ),
        ),
      ),
    );
  }
}
