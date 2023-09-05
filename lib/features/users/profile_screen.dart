import 'package:din/constants/gaps.dart';
import 'package:din/constants/sizes.dart';
import 'package:din/features/authentication/log_in_screen.dart';
import 'package:din/features/authentication/repos/authentication_repo.dart';
import 'package:din/features/users/edit_profile_screen.dart';
import 'package:din/features/users/change_password_screen.dart';
import 'package:din/features/users/view_models/users_view_model.dart';
import 'package:din/features/users/widgets/avatar.dart';
import 'package:din/features/users/widgets/profile_list_tile.dart';
import 'package:din/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  // BannerAd? banner;
  // TargetPlatform? os;

  // @override
  // void initState() {
  //   super.initState();

  //   banner = BannerAd(
  //     size: AdSize.banner,
  //     adUnitId: UNIT_ID[os == TargetPlatform.iOS ? 'ios' : 'android']!,
  //     listener: BannerAdListener(
  //       onAdFailedToLoad: (ad, error) {},
  //       onAdLoaded: (ad) {
  //         setState(() {});
  //       },
  //     ),
  //     request: AdRequest(),
  //   );

  //   banner?.load();
  // }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   os = Theme.of(context).platform;
  // }

  void _onLogoutTap() {
    ref.read(authRepo).signOut();
    context.go(LoginScreen.routeURL);
  }

  void _onPasswordChangeTap() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ChangePasswordScreen(),
      ),
    );
  }

  void _onEditProfileTap() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const EditProfileScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(usersProvider);

    final loginMethod = ref.read(usersProvider.notifier).getLoginMethod(ref);
    bool isLogo = loginMethod.isNotEmpty && loginMethod[0] == 'google.com';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          data.name,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
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
          Gaps.v16,
          Align(
            alignment: Alignment.center,
            child: Text(
              data.email,
              style: const TextStyle(fontSize: Sizes.size20),
            ),
          ),
          Gaps.v20,
          Divider(
            thickness: 0.5,
            color: Colors.grey.shade400,
            indent: Sizes.size10,
            endIndent: Sizes.size10,
          ),
          Gaps.v10,
          ProfileListTile(
            leadingIcon: Icons.check_circle_outline_rounded,
            title: "연결된 계정",
            subTitle: "연결된 로그인 방법을 확인",
            isLogo: isLogo,
            image: 'assets/images/google_logo.png',
            loginMethod: loginMethod.isNotEmpty ? loginMethod[0] : null,
          ),
          ProfileListTile(
            title: "프로필 변경",
            subTitle: '프로필 이미지와 사용자 이름 변경하기',
            leadingIcon: Icons.manage_accounts,
            isLogo: false,
            onPressed: _onEditProfileTap,
          ),
          if (loginMethod.isNotEmpty && loginMethod[0] == "password")
            ProfileListTile(
              title: "비밀번호 변경",
              subTitle: '현재 비밀번호 바꾸기',
              leadingIcon: Icons.lock_reset_rounded,
              isLogo: false,
              onPressed: _onPasswordChangeTap,
            ),
          // const ProfileListTile(
          //   title: "Notice",
          //   subTitle: "App improvements and revisions",
          //   leadingIcon: Icons.notification_add_outlined,
          //   isLogo: false,
          // ),
          ProfileListTile(
            title: "로그아웃",
            subTitle: "로그아웃 후 로그인 페이지로 이동",
            leadingIcon: Icons.logout_rounded,
            isLogo: false,
            onPressed: () => showModalBottomWithText(
              context,
              "로그아웃 하시겠습니까?",
              _onLogoutTap,
            ),
          ),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
            leading: const Icon(
              Icons.info_outline_rounded,
              size: 30,
            ),
            title: const Text("앱 버전"),
            subtitle: Text(
              '최종 업데이트 2023년 9월 5일',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade800,
              ),
            ),
            trailing: const Text(
              '1.0.0',
              style: TextStyle(
                fontSize: 14,
              ),
            ),
          ),
          Spacer(),
          // Container(
          //   height: 60,
          //   child: AdWidget(ad: banner!),
          // )
        ],
      ),
    );
  }
}
