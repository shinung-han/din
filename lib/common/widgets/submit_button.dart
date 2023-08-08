import 'package:din/constants/sizes.dart';
import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {
  final bool disabled;
  final Function() onTap;
  final String buttonText;
  final IconData? icon;
  final Color? color;

  const SubmitButton({
    required this.disabled,
    required this.onTap,
    required this.buttonText,
    this.icon,
    this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: disabled ? onTap : null,
      child: FractionallySizedBox(
        widthFactor: 1,
        child: Container(
          height: 70,
          padding: const EdgeInsets.symmetric(
            horizontal: Sizes.size18,
            vertical: Sizes.size16,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              width: 0.5,
              color: disabled ? Colors.black : Colors.grey.shade400,
            ),
            color: disabled ? Colors.black : Colors.grey.shade400,
            borderRadius: BorderRadius.circular(Sizes.size36),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: Sizes.size8),
                  child: Icon(
                    icon,
                    size: Sizes.size20,
                    color: disabled ? Colors.white : Colors.white,
                  ),
                ),
              ),
              Text(
                buttonText,
                style: TextStyle(
                  fontSize: Sizes.size16,
                  color: disabled ? Colors.white : Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
