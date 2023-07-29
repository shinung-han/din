import 'package:din/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CommonButton extends StatelessWidget {
  final String text;
  final IconData? icon;
  final Color? color, bgColor, borderColor;
  final FontWeight? fontWeight;
  final Function()? onTap;
  final Image? image;

  const CommonButton({
    required this.text,
    this.icon,
    this.onTap,
    this.color,
    this.bgColor,
    this.borderColor,
    this.fontWeight,
    this.image,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
              color: borderColor ?? Colors.grey.shade400,
            ),
            // borderRadius: BorderRadius.circular(Sizes.size5),
            borderRadius: BorderRadius.circular(Sizes.size36),
            color: bgColor,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (image != null)
                Align(
                  alignment: Alignment.centerLeft,
                  child: image,
                ),
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
                  fontSize: Sizes.size16,
                  fontWeight: fontWeight ?? FontWeight.normal,
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
