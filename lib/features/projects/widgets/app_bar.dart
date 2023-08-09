import 'package:din/features/projects/view_models/app_bar_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProjectAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final String? title;
  final Function()? onPressed;

  const ProjectAppBar({
    this.title,
    this.onPressed,
    super.key,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  String _dDay(DateTime startDate) {
    DateTime currentDate = DateTime.now();
    int difference =
        currentDate.difference(startDate.add(const Duration(days: 1))).inDays;

    if (difference < 0) {
      return "D$difference";
    } else if (difference == 0) {
      return "D+1";
    } else {
      return "D+${difference + 1}";
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final date = ref.watch(appBarProvider);

    return Consumer(
      builder: (context, ref, child) {
        return AppBar(
          title: Text(
            _dDay(date!.startDate),
            style: const TextStyle(
              fontWeight: FontWeight.w700,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 5),
              child: IconButton(
                onPressed: onPressed,
                icon: const Icon(
                  Icons.settings,
                  size: 30,
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
