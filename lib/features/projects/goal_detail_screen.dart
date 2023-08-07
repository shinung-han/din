import 'package:din/common/widgets/submit_button.dart';
import 'package:din/constants/gaps.dart';
import 'package:din/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class GoalDetailScreen extends ConsumerStatefulWidget {
  const GoalDetailScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _GoalDetailScreenState();
}

class _GoalDetailScreenState extends ConsumerState<GoalDetailScreen> {
  final GlobalKey<FormState> _globalKey = GlobalKey();

  Map<String, String> formData = {};

  late final TextEditingController _titleController = TextEditingController()
    ..addListener(() {
      updateButtonState();
      setState(() {
        formData['title'] = _titleController.text;
        formData['id'] = DateTime.now().millisecondsSinceEpoch.toString();
        formData['image'] = '';
      });
    });

  // late String _title;

  void _onDeleteTap() {
    setState(() {
      _titleController.clear();
    });
  }

  void updateButtonState() {
    setState(() {
      _isButtonEnabled = _titleController.text.isNotEmpty;
    });
  }

  bool _isButtonEnabled = false;

  void _onSubmit() {
    Navigator.pop(context, formData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              title: const Text(
                'Add goal',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              actions: [
                GestureDetector(
                  onTap: () {},
                  child: const Icon(
                    Icons.image_search_rounded,
                    size: 30,
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: const Icon(
                    Icons.delete_outline,
                    size: 30,
                  ),
                ),
              ],
            ),
            SliverPadding(
              padding: const EdgeInsets.all(Sizes.size20),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Form(
                      key: _globalKey,
                      child: Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: Colors.grey.shade400,
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FaIcon(
                                  FontAwesomeIcons.image,
                                  color: Colors.grey.shade400,
                                  size: 50,
                                ),
                                Gaps.v10,
                                Text(
                                  'Select Image',
                                  style: TextStyle(
                                    color: Colors.grey.shade500,
                                    fontSize: 20,
                                  ),
                                ),
                                Gaps.v10,
                                Text(
                                  'Images can be added and edited later',
                                  style: TextStyle(
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Gaps.v16,
                          TextFormField(
                            controller: _titleController,
                            keyboardType: TextInputType.emailAddress,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            cursorHeight: Sizes.size16,
                            autocorrect: false,
                            decoration: InputDecoration(
                              labelStyle:
                                  TextStyle(color: Colors.grey.shade400),
                              enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade400)),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey.shade400),
                              ),
                              suffix: Padding(
                                padding:
                                    const EdgeInsets.only(right: Sizes.size10),
                                child: GestureDetector(
                                  onTap: _onDeleteTap,
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
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 90,
        child: SubmitButton(
          buttonText: 'Create',
          disabled: _isButtonEnabled,
          onTap: _onSubmit,
        ),
      ),
    );
  }
}
