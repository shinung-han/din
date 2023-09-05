import 'package:din/common/widgets/common_button.dart';
import 'package:din/constants/gaps.dart';
import 'package:din/constants/sizes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

void showFirebaseErrorSnack(
  BuildContext context,
  Object? error,
) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      showCloseIcon: true,
      content: Text(
        (error as FirebaseException).message ==
                "The email address is already in use by another account."
            ? "동일한 계정이 존재합니다"
            : error.message.toString(),

        // (error as FirebaseException).message ?? "문제가 발생했습니다",
      ),
    ),
  );
}

void showErrorSnack(BuildContext context, String error) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      showCloseIcon: true,
      content: Text(error),
      duration: const Duration(milliseconds: 1500),
    ),
  );
}

bool emailValid(email) {
  return RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(email);
}

void showModalBottom(BuildContext context, List<Map<String, dynamic>> list) {
  showModalBottomSheet(
    backgroundColor: Colors.white,
    elevation: 0,
    context: context,
    builder: (context) {
      return Wrap(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(
                top: Sizes.size32,
                left: Sizes.size16,
                right: Sizes.size16,
              ),
              child: Column(
                children: _buildListItems(context, list),
              ),
            ),
          ),
        ],
      );
    },
  );
}

List<Widget> _buildListItems(
    BuildContext context, List<Map<String, dynamic>> list) {
  List<Widget> items = [];
  for (var item in list) {
    items.add(
      SizedBox(
        height: 66,
        child: CommonButton(
          text: item['text'],
          icon: item['icon'],
          onTap: () => item['onTap'](),
        ),
      ),
    );
    items.add(Gaps.v16);
  }

  items.add(
    SizedBox(
      height: 66,
      child: CommonButton(
        text: '취소',
        bgColor: Colors.black,
        color: Colors.white,
        icon: Icons.arrow_back_ios_new_rounded,
        onTap: () => Navigator.pop(context),
      ),
    ),
  );
  items.add(Gaps.v12);
  return items;
}

void showModalBottomWithText(
    BuildContext context, String title, Function() onTap) {
  showModalBottomSheet(
    backgroundColor: Colors.white,
    elevation: 0,
    context: context,
    builder: (context) {
      return Wrap(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(
                top: Sizes.size20,
                left: Sizes.size16,
                right: Sizes.size16,
              ),
              child: Column(
                children: [
                  Gaps.v20,
                  SizedBox(
                    height: 50,
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 17,
                      ),
                    ),
                  ),
                  Gaps.v20,
                  SizedBox(
                    height: 66,
                    child: CommonButton(
                      icon: Icons.task_alt_rounded,
                      text: '예',
                      bgColor: Colors.black,
                      color: Colors.white,
                      onTap: onTap,
                    ),
                  ),
                  Gaps.v16,
                  SizedBox(
                    height: 66,
                    child: CommonButton(
                      text: '취소',
                      bgColor: Colors.white,
                      color: Colors.black,
                      icon: Icons.arrow_back_ios_new_rounded,
                      onTap: () => Navigator.pop(context),
                    ),
                  ),
                  Gaps.v12,
                ],
              ),
            ),
          ),
        ],
      );
    },
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

Divider divider() {
  return Divider(
    color: Colors.grey.shade400,
    height: Sizes.size14,
    indent: 10,
    endIndent: 10,
    thickness: 0.5,
  );
}
