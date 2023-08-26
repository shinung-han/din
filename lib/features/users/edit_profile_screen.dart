import 'dart:io';

import 'package:din/common/widgets/common_appbar.dart';
import 'package:din/common/widgets/submit_button.dart';
import 'package:din/constants/gaps.dart';
import 'package:din/constants/sizes.dart';
import 'package:din/features/users/view_models/edit_profile_view_model.dart';
import 'package:din/features/users/view_models/users_view_model.dart';
import 'package:din/features/users/widgets/avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  void _onScaffoldTap() {
    FocusScope.of(context).unfocus();
  }

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isButtonEnabled = false;

  late final TextEditingController _nameController = TextEditingController()
    ..addListener(() {
      updateButtonState();
    });

  void updateButtonState() {
    setState(() {
      isButtonEnabled = _nameController.text.length > 1;
    });
  }

  void _onSubmit() {
    ref
        .read(editProfileProvider.notifier)
        .profileUpdate(context, _nameController.text);
  }

  void _onDeleteTap(controller) {
    setState(() {
      _nameController.clear();
    });
  }

  Future<void> _onChangeProfileImage(String oldFileName) async {
    final xFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 100,
      maxHeight: 200,
      maxWidth: 200,
      // 수정 전 : imageQuality : 50, maxHeight & maxWidth : 150
    );

    if (xFile != null) {
      final file = File(xFile.path);

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            content: Container(
              height: 130,
              color: Colors.white,
              width: MediaQuery.of(context).size.width * 0.55,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Colors.black),
                  Gaps.v16,
                  Text("Editing image.."),
                ],
              ),
            ),
          );
        },
      );
      await ref.read(usersProvider.notifier).onAvatarUpload(file, oldFileName);

      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(usersProvider);

    return GestureDetector(
      onTap: _onScaffoldTap,
      child: Scaffold(
        appBar: CommonAppBar(
          title: "Edit profile",
          icon: Icons.image_search_rounded,
          onPressed: () => _onChangeProfileImage(data.avatarUrl),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Sizes.size20),
            child: Column(
              children: [
                Gaps.v20,
                Hero(
                  tag: 'avatar',
                  child: Avatar(
                    name: data.name,
                    hasAvatar: data.hasAvatar,
                    avatarUrl: data.avatarUrl,
                    uid: data.uid,
                  ),
                ),
                Gaps.v20,
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nameController,
                        cursorHeight: Sizes.size16,
                        autocorrect: false,
                        maxLength: 16,
                        decoration: InputDecoration(
                          counterText: '',
                          labelStyle: TextStyle(color: Colors.grey.shade400),
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey.shade400)),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade400),
                          ),
                          labelText: 'New name',
                          suffix: Padding(
                            padding: const EdgeInsets.only(right: Sizes.size10),
                            child: GestureDetector(
                              onTap: () => _onDeleteTap(_nameController),
                              child: FaIcon(
                                FontAwesomeIcons.xmark,
                                size: Sizes.size18,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Gaps.v10,
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: Sizes.size4),
                          child: Text(
                            "The username can be between 2 and 16 characters.",
                            style: TextStyle(
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          height: 90,
          child: SubmitButton(
            icon: Icons.edit_outlined,
            disabled: isButtonEnabled,
            onTap: _onSubmit,
            buttonText: 'Edit',
          ),
        ),
      ),
    );
  }
}
