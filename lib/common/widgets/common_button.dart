import 'package:din/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CommonButton extends StatelessWidget {
  final String text;
  final IconData? icon;
  final Color? color, bgColor, borderColor;
  final Function()? onTap;

  const CommonButton({
    required this.text,
    this.icon,
    this.onTap,
    this.color,
    this.bgColor,
    this.borderColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: FractionallySizedBox(
        widthFactor: 1,
        child: Container(
          padding: const EdgeInsets.all(Sizes.size18),
          decoration: BoxDecoration(
            border: Border.all(
              width: 0.5,
              color: borderColor ?? Colors.grey.shade400,
            ),
            borderRadius: BorderRadius.circular(Sizes.size4),
            color: bgColor,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: Sizes.size8),
                  child: FaIcon(
                    icon,
                    size: Sizes.size20,
                    color: color ?? Colors.black,
                  ),
                ),
              ),
              Text(
                text,
                style: TextStyle(
                  // fontWeight: FontWeight.w500,
                  color: color ?? Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
