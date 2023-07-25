import 'package:din/constants/sizes.dart';
import 'package:flutter/material.dart';

class AuthBottomAppBar extends StatelessWidget {
  final String text, tapText;
  final Function()? onTap;

  const AuthBottomAppBar({
    required this.tapText,
    required this.onTap,
    required this.text,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.grey.shade100,
      elevation: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(text),
          const SizedBox(width: Sizes.size10),
          GestureDetector(
            onTap: onTap,
            child: Text(
              tapText,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
