import 'dart:io';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:din/constants/sizes.dart';
import 'package:din/features/projects/set_date_screen.dart';
import 'package:din/common/widgets/common_button.dart';
import 'package:din/constants/gaps.dart';
import 'package:din/features/authentication/widgets/auth_header.dart';
import 'package:din/features/projects/view_models/project_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CreateProjectFirstScreen extends ConsumerStatefulWidget {
  const CreateProjectFirstScreen({super.key});

  @override
  ConsumerState<CreateProjectFirstScreen> createState() =>
      _ProjectScreenState();
}

class _ProjectScreenState extends ConsumerState<CreateProjectFirstScreen> {
  void _requestTrackingAuthorization() async {
    if (Platform.isIOS) {
      await AppTrackingTransparency.requestTrackingAuthorization();
      // print(status);
    }
  }

  void _onCreateProject() {
    context.go('/home/${SetDateScreen.routeURL}');
  }

  void _onViewTutorial(user) {
    // ref.read(projectProvider.notifier).updateHasProject(!user.hasProject);
  }

  @override
  void initState() {
    super.initState();
    ref.read(projectProvider.notifier).loadUserProfile();
    _requestTrackingAuthorization();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final userModel = ref.watch(projectProvider);
        if (userModel!.isLoading) {
          return SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: Colors.black,
                  ),
                  Gaps.v40,
                  const Text(
                    '프로젝트 생성 중입니다',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: Sizes.size28,
                    ),
                  ),
                  Gaps.v10,
                  const Text(
                    '잠시만 기다려주세요',
                    style: TextStyle(
                      // fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const AuthHeader(
                        title: '프로젝트가 없습니다',
                        subTitle:
                            "어제의 나를 뛰어넘기 위한 놀라운 프로젝트를\n시작하세요. 당신의 내일이 더 빛나길 바랍니다!",
                      ),
                      CommonButton(
                        text: '프로젝트 생성',
                        bgColor: Colors.black,
                        color: Colors.white,
                        icon: Icons.add_location_alt_outlined,
                        onTap: _onCreateProject,
                      ),
                      Gaps.v16,
                      CommonButton(
                        text: '튜토리얼 보기',
                        onTap: () => _onViewTutorial(userModel),
                        icon: Icons.navigation_outlined,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
