import 'dart:io';

import 'package:din/common/widgets/submit_button.dart';
import 'package:din/constants/gaps.dart';
import 'package:din/constants/sizes.dart';
import 'package:din/features/projects/models/goal_model.dart';
import 'package:din/features/projects/view_models/goal_list_view_model.dart';
import 'package:din/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

class AddGoalScreen extends ConsumerStatefulWidget {
  final List<GoalModel> goalList;

  const AddGoalScreen({
    super.key,
    required this.goalList,
  });

  @override
  ConsumerState<AddGoalScreen> createState() => _ListSettingScreenState();
}

class _ListSettingScreenState extends ConsumerState<AddGoalScreen> {
  void _onScaffoldTap() {
    FocusScope.of(context).unfocus();
  }

  Map<String, dynamic> formData = {};

  final ImagePicker _imagePicker = ImagePicker();

  File? _imageFile;

  Future<void> _onSelectImage() async {
    final pickedFile = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 100,
      maxHeight: 500,
      maxWidth: 500,
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

  void _onSubmit(goalList) {
    final id = DateTime.now().millisecondsSinceEpoch;
    final title = titleController.text;
    bool isDuplicate = false;

    for (var goal in goalList) {
      if (goal.title.contains(title)) {
        isDuplicate = true;
        break;
      }
    }

    if (isDuplicate) {
      showErrorSnack(context, "동일한 제목이 존재합니다");
      return;
    }

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
    // final goalList = ref.watch(goalListProvider);

    return GestureDetector(
      onTap: _onScaffoldTap,
      child: Scaffold(
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                title: const Text(
                  "목표 추가",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: Sizes.size5),
                    child: IconButton(
                      onPressed: _onSelectImage,
                      icon: const Icon(
                        Icons.add_photo_alternate_outlined,
                        size: 30,
                      ),
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
                                    child: Center(
                                      child: Icon(
                                        Icons.image_not_supported_outlined,
                                        color: Colors.grey.shade400,
                                        size: 50,
                                      ),
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
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              cursorHeight: Sizes.size16,
                              autocorrect: false,
                              maxLength: 20,
                              decoration: InputDecoration(
                                labelStyle:
                                    TextStyle(color: Colors.grey.shade400),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey.shade400)),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade400),
                                ),
                                suffix: Padding(
                                  padding: const EdgeInsets.only(
                                      right: Sizes.size10),
                                  child: GestureDetector(
                                    onTap: _onDeleteTap,
                                    child: FaIcon(
                                      FontAwesomeIcons.xmark,
                                      size: Sizes.size18,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ),
                                labelText: '제목',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          height: 128,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.grey.shade500,
                  ),
                  Gaps.h5,
                  Text(
                    "이미지, 제목은 프로젝트 생성 후 변경할 수 있습니다",
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                ],
              ),
              Gaps.v10,
              Container(
                height: 66,
                child: SubmitButton(
                  buttonText: '추가',
                  disabled: isButtonEnabled,
                  onTap: () => _onSubmit(widget.goalList),
                  icon: Icons.add_circle_outline_rounded,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
