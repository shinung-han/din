import 'dart:math';

import 'package:din/common/widgets/main_navigation_screen.dart';
import 'package:din/constants/gaps.dart';
import 'package:din/features/projects/edit_project_screen.dart';
import 'package:din/features/projects/view_models/project_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class QuoteScreen extends ConsumerStatefulWidget {
  const QuoteScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _QuoteScreenState();
}

class _QuoteScreenState extends ConsumerState<QuoteScreen> {
  // late List<Map<String, dynamic>> settingModalList;

  @override
  void initState() {
    super.initState();
    // settingModalList = [
    //   {
    //     "text": "프로젝트 설정",
    //     "icon": Icons.build_outlined,
    //     "onTap": () => _onEditProjectTap(),
    //   },
    // ];
    _generateRandomQuote();
  }

  // void _onEditProjectTap() {
  //   Navigator.pop(context);
  //   context.go('/home/${EditProjectScreen.routeURL}');
  // }

  String _loadStartDate(DateTime date) {
    DateTime currentDate = DateTime.now();

    DateTime normalizedCurrentDate =
        DateTime(currentDate.year, currentDate.month, currentDate.day);
    DateTime normalizedStartDate = DateTime(date.year, date.month, date.day);

    int difference =
        normalizedCurrentDate.difference(normalizedStartDate).inDays;

    if (difference > 0) {
      final user = ref.watch(projectProvider);

      ref
          .read(projectProvider.notifier)
          .updateHasProject(false, DateTime.now());
      ref.read(projectProvider.notifier).deleteProject(user!.uid);

      Navigator.popUntil(
          context, ModalRoute.withName(MainNavigationScreen.routeName));
    }

    return "D$difference";
  }

  Quote? randomQuote;

  _generateRandomQuote() {
    final random = Random();
    setState(() {
      randomQuote = quotes[random.nextInt(quotes.length)];
    });
  }

  @override
  Widget build(BuildContext context) {
    final startDate = ref.watch(projectProvider)!.startDate;

    return Scaffold(
      appBar: AppBar(actions: [
        Padding(
          padding: const EdgeInsets.only(right: 5),
          child: IconButton(
            onPressed: () => context.go('/home/${EditProjectScreen.routeURL}'),
            icon: const Icon(
              Icons.settings,
              size: 30,
            ),
          ),
        )
      ]),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _loadStartDate(startDate!),
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Gaps.v48,
              Text(
                randomQuote?.text ?? "",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              Gaps.v20,
              Text(
                randomQuote?.author ?? "",
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
              Gaps.v40,
            ],
          ),
        ),
      ),
    );
  }
}

class Quote {
  final String text;
  final String author;

  Quote(this.text, this.author);
}

final List<Quote> quotes = [
  Quote(
      "The ultimate measure of a man is not where he stands in moments of comfort and convenience, but where he stands at times of challenge and controversy.",
      "Martin Luther King Jr."),
  Quote(
      "Life is not easy for any of us. But what of that? We must have perseverance and above all confidence in ourselves. We must believe that we are gifted for something and that this thing must be attained.",
      "Marie Curie"),
  Quote("The future belongs to those who believe in the beauty of their dreams",
      "Eleanor Roosevelt"),
  Quote(
      "Your work is going to fill a large part of your life, and the only way to be truly satisfied is to do what you believe is great work. And the only way to do great work is to love what you do",
      "Steve Jobs"),
  Quote(
      "The biggest adventure you can ever take is to live the life of your dreams",
      "Oprah Winfrey"),
  Quote(
      "Life is like riding a bicycle. To keep your balance, you must keep moving",
      "Albert Einstein"),
  Quote(
      "Character cannot be developed in ease and quiet. Only through experience of trial and suffering can the soul be strengthened, ambition inspired, and success achieved.",
      "Helen Keller"),
  Quote(
      "Do not wait until the conditions are perfect to begin. Beginning makes the conditions perfect",
      "Alan Cohen"),
];
