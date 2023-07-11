import 'package:flutter/material.dart';

class authDivider extends StatelessWidget {
  const authDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Divider(
          thickness: 0.5,
          color: Colors.grey.shade400,
        ),
        Container(
          width: 30,
          // height: 30,
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: Text(
            'or',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey.shade400,
            ),
          ),
        )
      ],
    );
  }
}
