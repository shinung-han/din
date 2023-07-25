import 'package:din/common/widgets/common_button.dart';
import 'package:din/constants/gaps.dart';
import 'package:din/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  late final TextEditingController _textEditingController =
      TextEditingController()
        ..addListener(() {
          // if (_textEditingController.text.length >= 6) {
          //   setState(() {
          //     _isButtonEnabled = true;
          //   });
          // }
        });

  bool _obscureText = false;

  bool _isButtonEnabled = false;

  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _onDeleteTap() {
    _textEditingController.clear();
  }

  void _onSubmitTap() {
    if (_formKey.currentState != null) {
      if (_formKey.currentState!.validate()) {
        print('통과');
        setState(() {
          _isButtonEnabled = true;
        });
      }
    } else {
      print('스낵바 출동');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Change Password',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(Sizes.size20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _textEditingController,
                autocorrect: false,
                obscureText: _obscureText,
                maxLength: 20,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  // if (value.toString().length < 5) {
                  //   return 'Username cannot be empty';
                  // }
                  return null;
                },
                decoration: InputDecoration(
                  helperText: "6자리 이상 20자리 이하",
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
                            _obscureText
                                ? FontAwesomeIcons.eye
                                : FontAwesomeIcons.eyeSlash,
                            size: Sizes.size18,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        Gaps.h12,
                        GestureDetector(
                          onTap: _onDeleteTap,
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
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: CommonButton(
          text: "Change",
          bgColor: Colors.black,
          color: Colors.white,
          onTap: _onSubmitTap,
        ),
      ),
    );
  }
}
