import 'dart:io';

import 'package:din/common/widgets/submit_button.dart';
import 'package:din/constants/gaps.dart';
import 'package:din/constants/sizes.dart';
import 'package:din/features/users/view_models/avatar_view_model.dart';
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
      setState(() {
        _newName = _nameController.text;
      });
    });

  String _newName = '';

  void updateButtonState() {
    setState(() {
      isButtonEnabled = _nameController.text.length > 1;
    });
  }

  void _onSubmit() {
    ref.read(editProfileProvider.notifier).profileUpdate(context, _newName);
  }

  void _onDeleteTap(controller) {
    setState(() {
      _nameController.clear();
    });
  }

  Future<void> _onChangeProfileImage() async {
    final xFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 100,
      maxHeight: 200,
      maxWidth: 200,
      // 수정 전 : imageQuality : 50, maxHeight & maxWidth : 150
    );
    if (xFile != null) {
      final file = File(xFile.path);
      ref.read(avatarProvider.notifier).uploadAvatar(file);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(usersProvider).when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => Center(child: Text(error.toString())),
          data: (data) {
            final isLoading = ref.watch(avatarProvider).isLoading;

            return GestureDetector(
              onTap: _onScaffoldTap,
              child: Scaffold(
                appBar: AppBar(
                  title: const Text('Edit Profile'),
                ),
                body: SafeArea(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: Sizes.size20),
                    child: Column(
                      children: [
                        Gaps.v20,
                        isLoading
                            ? Container(
                                width: 130,
                                height: 130,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    width: 1,
                                    color: Colors.grey.shade200,
                                  ),
                                  color: Colors.grey.shade200,
                                ),
                                child: const CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              )
                            : Stack(
                                children: [
                                  Hero(
                                    tag: 'avatar',
                                    child: Avatar(
                                      name: data.name,
                                      hasAvatar: data.hasAvatar,
                                      uid: data.uid,
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: GestureDetector(
                                      onTap: isLoading
                                          ? null
                                          : _onChangeProfileImage,
                                      child: CircleAvatar(
                                        radius: 20,
                                        backgroundColor: Colors.white,
                                        child: Container(
                                          width: 35,
                                          height: 35,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.grey.shade400,
                                            // border: Border.all(
                                            //   width: 1,
                                            //   color: Colors.grey.shade500,
                                            // ),
                                          ),
                                          child: const Center(
                                            child: Icon(
                                              Icons.image_search_rounded,
                                              size: 20,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
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
                                // onFieldSubmitted: (_) => _onSubmit(),
                                maxLength: 16,
                                decoration: InputDecoration(
                                  counterText: '',
                                  labelStyle:
                                      TextStyle(color: Colors.grey.shade400),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey.shade400)),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.grey.shade400),
                                  ),
                                  labelText: 'New name',
                                  suffix: Padding(
                                    padding: const EdgeInsets.only(
                                        right: Sizes.size10),
                                    child: GestureDetector(
                                      onTap: () =>
                                          _onDeleteTap(_nameController),
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
                                  padding:
                                      const EdgeInsets.only(left: Sizes.size4),
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
                    disabled: isButtonEnabled,
                    onTap: _onSubmit,
                    buttonText: 'Edit',
                  ),
                ),
              ),
            );
          },
        );
  }
}
