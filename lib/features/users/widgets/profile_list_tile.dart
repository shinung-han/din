import 'package:din/constants/sizes.dart';
import 'package:flutter/material.dart';

class ProfileListTile extends StatelessWidget {
  final String title;
  final String subTitle;
  final IconData leadingIcon;
  final IconData? trailingIcon;
  final Function()? onPressed;
  final bool isLogo;
  final String? image;
  final String? loginMethod;

  const ProfileListTile({
    required this.title,
    required this.subTitle,
    required this.leadingIcon,
    required this.isLogo,
    this.image,
    this.onPressed,
    this.trailingIcon,
    this.loginMethod,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.only(
        left: Sizes.size20,
        right: Sizes.size5,
      ),
      leading: Icon(
        leadingIcon,
        size: Sizes.size32,
      ),
      title: Text(title),
      subtitle: Text(
        subTitle,
        style: TextStyle(
          fontSize: 13,
          color: Colors.grey.shade800,
        ),
      ),
      trailing: isLogo
          ? Padding(
              padding: const EdgeInsets.only(right: Sizes.size10),
              child: Image.asset(
                '$image',
                scale: Sizes.size16,
              ),
            )
          : IconButton(
              onPressed: onPressed,
              icon: Icon(
                loginMethod == 'password'
                    ? Icons.alternate_email_outlined
                    : Icons.chevron_right,
                size: Sizes.size36,
              ),
            ),
    );
  }
}
