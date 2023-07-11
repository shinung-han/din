import 'package:din/constants/sizes.dart';
import 'package:flutter/material.dart';

class AuthBottomAppBar extends StatelessWidget {
  final String tapText;
  final Function()? onTap;

  const AuthBottomAppBar({
    required this.tapText,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.grey.shade50.withOpacity(0.1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Already have an account?'),
          const SizedBox(width: Sizes.size10),
          GestureDetector(
            onTap: onTap,
            child: Text(
              tapText,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
