import 'dart:io';

import 'package:din/common/widgets/common_appbar.dart';
import 'package:din/common/widgets/submit_button.dart';
import 'package:din/constants/gaps.dart';
import 'package:din/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

class AddGoalScreen extends StatefulWidget {
  const AddGoalScreen({super.key});

  @override
  State<AddGoalScreen> createState() => _ListSettingScreenState();
}

class _ListSettingScreenState extends State<AddGoalScreen> {
  Map<String, dynamic> formData = {};

  final ImagePicker _imagePicker = ImagePicker();

  Future<void> _onSelectImage() async {
    final pickedFile = await _imagePicker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      final File imageFile = File(pickedFile.path);
      setState(() {
        formData['image'] = imageFile;
      });
    }
  }

  final GlobalKey<FormState> globalKey = GlobalKey();

  late final TextEditingController titleController = TextEditingController()
    ..addListener(() {
      updateButtonState();
      setState(() {
        formData['title'] = titleController.text;
        formData['id'] = DateTime.now().millisecondsSinceEpoch.toString();
      });
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
    if (formData['image'] == null) {
      setState(() {
        formData["image"] = null;
        formData["hasImage"] = false;
      });
      Navigator.pop(context, formData);
    } else {
      setState(() {
        formData["hasImage"] = true;
      });
      // print(formData['image'].runtimeType);
      Navigator.pop(context, formData);
    }
  }

  @override
  Widget build(BuildContext context) {
    // print("addGoalScreen: ${formData['image']}");

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
                  formData['image'] == null
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
                                formData['image'],
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
