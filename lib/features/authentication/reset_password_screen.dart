import 'package:din/common/widgets/common_appbar.dart';
import 'package:din/common/widgets/submit_button.dart';
import 'package:din/constants/gaps.dart';
import 'package:din/constants/sizes.dart';
import 'package:din/features/authentication/view_models/login_view_model.dart';
import 'package:din/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  void _onScaffoldTap() {
    FocusScope.of(context).unfocus();
  }

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late final TextEditingController _emailController = TextEditingController()
    ..addListener(() {
      updateButtonState();
    });

  void updateButtonState() {
    setState(() {
      isButtonEnabled = emailValid(_emailController.text);
    });
  }

  void _onDeleteTap(controller) {
    setState(() {
      _emailController.clear();
    });
  }

  void _onSubmit() {
    ref
        .read(loginProvider.notifier)
        .sendPasswordResetEmail(_emailController.text);
    showErrorSnack(context, "이메일이 전송되었습니다");
  }

  bool isButtonEnabled = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onScaffoldTap,
      child: Scaffold(
        appBar: const CommonAppBar(title: "비밀번호 재설정"),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(Sizes.size20),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _emailController,
                    cursorHeight: Sizes.size16,
                    autocorrect: false,
                    keyboardType: TextInputType.emailAddress,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                      labelStyle: TextStyle(color: Colors.grey.shade400),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade400)),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade400),
                      ),
                      labelText: "이메일",
                      suffix: Padding(
                        padding: const EdgeInsets.only(right: Sizes.size10),
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
                  Gaps.v10,
                  Padding(
                    padding: const EdgeInsets.only(left: 3),
                    child: Text(
                      "비밀번호 재설정을 위한 이메일 주소를 입력해 주세요",
                      style: TextStyle(
                        color: Colors.grey.shade700,
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
            disabled: isButtonEnabled,
            onTap: _onSubmit,
            buttonText: '전송',
            icon: Icons.mark_email_unread_outlined,
          ),
        ),
      ),
    );
  }
}
