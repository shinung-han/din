import 'package:flutter/material.dart';

class AuthPolicy extends StatelessWidget {
  const AuthPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      'By continuing, you agree to our Terms of Service and acknowledge that you have read our Privacy Policy to learn how we collect, use, and share your data.',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 12,
      ),
    );
  }
}
