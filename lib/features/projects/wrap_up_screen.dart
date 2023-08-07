import 'package:din/common/widgets/common_button.dart';
import 'package:din/constants/gaps.dart';
import 'package:din/constants/sizes.dart';
import 'package:din/features/projects/widgets/goal_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class WrapUpScreen extends ConsumerStatefulWidget {
  const WrapUpScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WrapUpScreenState();
}

class _WrapUpScreenState extends ConsumerState<WrapUpScreen> {
  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w500,
    );

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            const SliverAppBar(
              title: Text('Wrap up'),
              // pinned: true,
            ),
            SliverPadding(
              padding: const EdgeInsets.all(Sizes.size20),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Column(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Gaps.v40,
                        const Text(
                          "Are you ready?",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                          ),
                        ),
                        const Text(
                          "Create your own fantastic project to become a better version of yourself than yesterday.",
                          textAlign: TextAlign.center,
                        ),
                        Gaps.v40,
                        // Divider(
                        //   color: Colors.grey.shade400,
                        //   indent: 10,
                        //   endIndent: 10,
                        //   thickness: 0.5,
                        // ),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Date information',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        Gaps.v20,
                        IntrinsicHeight(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  const Text(
                                    'Start date',
                                    style: textStyle,
                                  ),
                                  Gaps.v4,
                                  Text(DateFormat.yMd().format(DateTime.now())),
                                ],
                              ),
                              verticalDivider(),
                              Column(
                                children: [
                                  const Text(
                                    'End date',
                                    style: textStyle,
                                  ),
                                  Gaps.v4,
                                  Text(DateFormat.yMd().format(DateTime.now())),
                                ],
                              ),
                              verticalDivider(),
                              const Column(
                                children: [
                                  Text(
                                    'Duration',
                                    style: textStyle,
                                  ),
                                  Gaps.v4,
                                  Text('For ${20 + 1} days'),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Gaps.v20,
                        // Divider(
                        //   color: Colors.grey.shade400,
                        //   indent: 10,
                        //   endIndent: 10,
                        //   thickness: 0.5,
                        // ),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Goal list',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        Gaps.v20,
                        const Column(
                          children: [
                            GoalListTile(title: 'Hello', index: 1),
                            Gaps.v8,
                            GoalListTile(title: 'Hello', index: 1),
                            Gaps.v8,
                            GoalListTile(title: 'Hello', index: 1),
                            Gaps.v8,
                            GoalListTile(title: 'Hello', index: 1),
                            Gaps.v8,
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      /* appBar: const CommonAppBar(title: 'Wrap up'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Sizes.size20),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gaps.v40,
            const Text(
              "Are you ready?",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),
            const Text(
              "Create your own fantastic project to become a better version of yourself than yesterday.",
              textAlign: TextAlign.center,
            ),
            Gaps.v40,
            // Divider(
            //   color: Colors.grey.shade400,
            //   indent: 10,
            //   endIndent: 10,
            //   thickness: 0.5,
            // ),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Date information',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ),
            ),
            Gaps.v20,
            IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      const Text(
                        'Start date',
                        style: textStyle,
                      ),
                      Gaps.v4,
                      Text(DateFormat.yMd().format(DateTime.now())),
                    ],
                  ),
                  verticalDivider(),
                  Column(
                    children: [
                      const Text(
                        'End date',
                        style: textStyle,
                      ),
                      Gaps.v4,
                      Text(DateFormat.yMd().format(DateTime.now())),
                    ],
                  ),
                  verticalDivider(),
                  const Column(
                    children: [
                      Text(
                        'Duration',
                        style: textStyle,
                      ),
                      Gaps.v4,
                      Text('For ${20 + 1} days'),
                    ],
                  ),
                ],
              ),
            ),
            Gaps.v20,
            // Divider(
            //   color: Colors.grey.shade400,
            //   indent: 10,
            //   endIndent: 10,
            //   thickness: 0.5,
            // ),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Goal list',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ),
            ),
            Gaps.v20,
            const Column(
              children: [
                GoalListTile(title: 'Hello', index: 1),
                Gaps.v8,
                GoalListTile(title: 'Hello', index: 1),
                Gaps.v8,
                GoalListTile(title: 'Hello', index: 1),
                Gaps.v8,
                GoalListTile(title: 'Hello', index: 1),
                Gaps.v8,
              ],
            )
          ],
        ),
      ), */
      bottomNavigationBar: BottomAppBar(
        height: 90,
        child: CommonButton(
          text: "Done",
          bgColor: Colors.black,
          color: Colors.white,
          onTap: () {},
          icon: Icons.arrow_forward_ios_rounded,
        ),
      ),
    );
  }

  VerticalDivider verticalDivider() {
    return VerticalDivider(
      width: Sizes.size1,
      indent: Sizes.size8,
      endIndent: Sizes.size8,
      color: Colors.grey.shade400,
      thickness: 0.5,
    );
  }
}
