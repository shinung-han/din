import 'dart:io';

import 'package:din/common/widgets/common_appbar.dart';
import 'package:din/common/widgets/submit_button.dart';
import 'package:din/constants/gaps.dart';
import 'package:din/constants/sizes.dart';
import 'package:din/features/projects/models/goal_model.dart';
import 'package:din/features/projects/view_models/goal_list_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

class AddGoalScreen extends ConsumerStatefulWidget {
  const AddGoalScreen({super.key});

  @override
  ConsumerState<AddGoalScreen> createState() => _ListSettingScreenState();
}

class _ListSettingScreenState extends ConsumerState<AddGoalScreen> {
  Map<String, dynamic> formData = {};

  final ImagePicker _imagePicker = ImagePicker();

  File? _imageFile;

  Future<void> _onSelectImage() async {
    final pickedFile = await _imagePicker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  final GlobalKey<FormState> globalKey = GlobalKey();

  late final TextEditingController titleController = TextEditingController()
    ..addListener(() {
      updateButtonState();
    });

  void _onDeleteTap() {
    setState(() {
      titleController.clear();
    });
  }

  void updateButtonState() {
    setState(() {
      isButtonEnabled = titleController.text.isNotEmpty;
    });
  }

  bool isButtonEnabled = false;

  void _onSubmit() {
    final id = DateTime.now().millisecondsSinceEpoch;
    final title = titleController.text;

    if (_imageFile == null) {
      ref.read(goalListProvider.notifier).addGoal(
            GoalModel(
              id: id,
              title: title,
              image: null,
            ),
          );
      Navigator.pop(context);
    } else {
      ref.read(goalListProvider.notifier).addGoal(
            GoalModel(
              id: id,
              title: title,
              image: _imageFile,
            ),
          );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: CommonAppBar(
        title: 'Add Goal',
        icon: Icons.add_photo_alternate_outlined,
        onPressed: _onSelectImage,
      ),
      body: Padding(
        padding: const EdgeInsets.all(Sizes.size20),
        child: Column(
          children: [
            Form(
              key: globalKey,
              child: Column(
                children: [
                  _imageFile == null
                      ? Container(
                          width: size.width,
                          height: size.width,
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
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.north_east_rounded,
                                    color: Colors.grey.shade400,
                                    size: 50,
                                  ),
                                  Icon(
                                    Icons.add_photo_alternate_outlined,
                                    color: Colors.grey.shade400,
                                    size: 50,
                                  ),
                                ],
                              ),
                              Gaps.v10,
                              Text(
                                'Tap the icon at the top to select an image',
                                style: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontSize: 16,
                                ),
                              ),
                              Gaps.v10,
                              Text(
                                'Image can be added and edited later',
                                style: TextStyle(
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container(
                          width: size.width,
                          height: size.width,
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Colors.grey.shade400,
                            ),
                            borderRadius: BorderRadius.circular(5),
                            image: DecorationImage(
                              image: FileImage(
                                _imageFile!,
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                  Gaps.v16,
                  TextFormField(
                    controller: titleController,
                    keyboardType: TextInputType.emailAddress,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    cursorHeight: Sizes.size16,
                    autocorrect: false,
                    maxLength: 20,
                    decoration: InputDecoration(
                      labelStyle: TextStyle(color: Colors.grey.shade400),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade400)),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade400),
                      ),
                      suffix: Padding(
                        padding: const EdgeInsets.only(right: Sizes.size10),
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
      bottomNavigationBar: BottomAppBar(
        height: 90,
        child: SubmitButton(
          buttonText: 'Create',
          disabled: isButtonEnabled,
          onTap: _onSubmit,
        ),
      ),
    );
  }
}
