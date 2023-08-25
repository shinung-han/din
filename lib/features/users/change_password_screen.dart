import 'package:din/common/widgets/common_appbar.dart';
import 'package:din/common/widgets/submit_button.dart';
import 'package:din/features/users/view_models/change_password_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../constants/gaps.dart';
import '../../constants/sizes.dart';

class ChangePasswordScreen extends ConsumerStatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  void _onScaffoldTap() {
    FocusScope.of(context).unfocus();
  }

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late final TextEditingController passwordController = TextEditingController()
    ..addListener(() {
      updateButtonState();
      setState(() {
        _newPassword = passwordController.text;
      });
    });

  String _newPassword = '';

  void updateButtonState() {
    setState(() {
      isButtonEnabled = passwordController.text.length > 5;
    });
  }

  bool obscureText = false;

  void _toggleObscureText() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  bool isButtonEnabled = false;

  void _onSubmit() {
    ref.read(changePasswordProvider.notifier).passwordUpdate(
          context,
          _newPassword,
        );
  }

  void _onDeleteTap(controller) {
    setState(() {
      passwordController.clear();
    });
  }

  @override
  void dispose() {
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onScaffoldTap,
      child: Scaffold(
        appBar: CommonAppBar(
          title: "Password Change",
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(Sizes.size20),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: passwordController,
                    obscureText: obscureText,
                    cursorHeight: Sizes.size16,
                    autocorrect: false,
                    onFieldSubmitted: (_) => _onSubmit(),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                      labelStyle: TextStyle(color: Colors.grey.shade400),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade400)),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade400),
                      ),
                      labelText: 'New Password',
                      suffix: Padding(
                        padding: const EdgeInsets.only(right: Sizes.size10),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                              onTap: _toggleObscureText,
                              child: FaIcon(
                                obscureText
                                    ? FontAwesomeIcons.eye
                                    : FontAwesomeIcons.eyeSlash,
                                size: Sizes.size18,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            Gaps.h12,
                            GestureDetector(
                              onTap: () => _onDeleteTap(passwordController),
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
                  Gaps.v10,
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: Sizes.size4),
                      child: Text(
                        'Please enter a password of at least 6 digits.',
                        style: TextStyle(
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          height: 90,
          child: SubmitButton(
            icon: Icons.edit_outlined,
            disabled: isButtonEnabled,
            onTap: _onSubmit,
            buttonText: 'Edit',
          ),
        ),
      ),
    );
  }
}
