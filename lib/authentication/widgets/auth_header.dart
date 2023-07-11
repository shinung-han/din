import 'package:din/constants/gaps.dart';
import 'package:flutter/material.dart';

class AuthHeader extends StatelessWidget {
  final String title;
  final String subTitle;

  const AuthHeader({
    required this.title,
    required this.subTitle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Gaps.v60,
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
          Gaps.v10,
          Text(
            subTitle,
            textAlign: TextAlign.center,
          ),
          Gaps.v60,
        ],
      ),
    );
  }
}
