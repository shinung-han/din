import 'package:din/constants/gaps.dart';
import 'package:din/constants/sizes.dart';
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
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
          Gaps.v14,
          Text(
            subTitle,
            style: TextStyle(fontSize: Sizes.size16),
            textAlign: TextAlign.center,
          ),
          Gaps.v60,
        ],
      ),
    );
  }
}
