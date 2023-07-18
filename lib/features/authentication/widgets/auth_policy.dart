import 'package:flutter/material.dart';

class AuthPolicy extends StatelessWidget {
  const AuthPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 20,
        // vertical: 20,
      ),
      child: Text(
        'By continuing, you agree to our Terms of Service and acknowledge that you have read our Privacy Policy to learn how we collect, use, and share your data.',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 12,
        ),
      ),
    );
  }
}
