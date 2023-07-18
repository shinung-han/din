import 'package:din/constants/sizes.dart';
import 'package:flutter/material.dart';

class AuthSubmitButton extends StatelessWidget {
  final bool disabled;
  final Function() onTap;
  final String buttonText;

  const AuthSubmitButton({
    required this.disabled,
    required this.onTap,
    required this.buttonText,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: disabled ? onTap : null,
      child: FractionallySizedBox(
        widthFactor: 1,
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(Sizes.size18),
          decoration: BoxDecoration(
            border: Border.all(
              width: 0.5,
              color: Colors.grey.shade300,
            ),
            color: disabled ? Colors.black : Colors.white,
            borderRadius: BorderRadius.circular(Sizes.size5),
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
