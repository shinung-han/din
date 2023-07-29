import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class GoalCard extends StatelessWidget {
  final String title, id;
  final int index;
  final Function(int, String, String)? onTap;

  const GoalCard({
    required this.title,
    required this.id,
    required this.index,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0.1,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          radius: 30,
          backgroundImage: AssetImage(
            'assets/images/${index + 1}.jpg',
          ),
          // child: Text('Hello'),
        ),
        /* leading: const Icon(
                Icons.account_circle_rounded,
                size: 40,
              ), */
        title: Text(title),
        subtitle: Text(id),
        trailing: GestureDetector(
          onTap: () {
            if (onTap != null) {
              onTap!(index, title, id);
            }
          },
          child: const FaIcon(FontAwesomeIcons.ellipsis),
        ),
      ),
    );
  }
}
