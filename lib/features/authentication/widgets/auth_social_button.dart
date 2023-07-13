import 'package:din/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AuthSocialButton extends StatelessWidget {
  final String company;
  final IconData? icon;
  final Function()? onTap;

  const AuthSocialButton({
    required this.company,
    this.icon,
    this.onTap,
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
              color: Colors.grey.shade400,
            ),
            borderRadius: BorderRadius.circular(Sizes.size4),
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
                  ),
                ),
              ),
              Text(
                company,
                style: const TextStyle(
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
