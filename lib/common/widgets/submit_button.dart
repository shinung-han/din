import 'package:din/constants/sizes.dart';
import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {
  final bool disabled;
  final Function() onTap;
  final String buttonText;

  const SubmitButton({
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
          padding: const EdgeInsets.all(Sizes.size16),
          decoration: BoxDecoration(
            border: Border.all(
              width: 0.5,
              color: Colors.grey.shade400,
            ),
            color: disabled ? Colors.black : Colors.grey.shade400,
            borderRadius: BorderRadius.circular(Sizes.size36),
          ),
          child: Text(
            buttonText,
            style: TextStyle(
              fontSize: Sizes.size16,
              color: disabled ? Colors.white : Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
