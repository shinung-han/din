import 'package:din/common/widgets/common_button.dart';
import 'package:din/constants/gaps.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'constants/sizes.dart';

class ProjectDetailScreen extends StatefulWidget {
  final int index;

  const ProjectDetailScreen({
    required this.index,
    super.key,
  });

  @override
  State<ProjectDetailScreen> createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends State<ProjectDetailScreen> {
  void _onScaffoldTap() {
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    print(size.width);

    return GestureDetector(
      onTap: _onScaffoldTap,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Create Project',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Hero(
                tag: '${widget.index}',
                child: Container(
                  width: 350,
                  height: 350,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400, width: 0.5),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  /* decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        'assets/images/${widget.index}.jpg',
                      ),
                    ),
                  ), */
                  child: Center(
                    child: FaIcon(
                      FontAwesomeIcons.image,
                      size: 40,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Form(
                      child: Column(
                        children: [
                          TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            cursorHeight: Sizes.size16,
                            autocorrect: false,
                            decoration: InputDecoration(
                              labelStyle: const TextStyle(color: Colors.grey),
                              enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey)),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              suffix: Padding(
                                padding:
                                    const EdgeInsets.only(right: Sizes.size10),
                                child: GestureDetector(
                                  onTap: () {},
                                  child: FaIcon(
                                    FontAwesomeIcons.xmark,
                                    size: Sizes.size18,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ),
                              labelText: 'Title',
                            ),
                          ),
                          Gaps.v14,
                          TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            cursorHeight: Sizes.size16,
                            autocorrect: false,
                            keyboardType: TextInputType.multiline,
                            minLines: 1,
                            maxLines: 3,
                            decoration: InputDecoration(
                              labelStyle: const TextStyle(color: Colors.grey),
                              enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey)),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              suffix: Padding(
                                padding:
                                    const EdgeInsets.only(right: Sizes.size10),
                                child: GestureDetector(
                                  onTap: () {},
                                  child: FaIcon(
                                    FontAwesomeIcons.xmark,
                                    size: Sizes.size18,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ),
                              labelText: 'Description',
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          child: CommonButton(
            text: 'Complete',
            bgColor: Colors.black,
            color: Colors.white,
            onTap: () {},
          ),
        ),
      ),
    );
  }
}
