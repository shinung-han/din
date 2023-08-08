import 'package:din/features/users/view_models/avatar_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Avatar extends ConsumerWidget {
  final String name;
  final String uid;
  final bool hasAvatar;

  const Avatar({
    super.key,
    required this.name,
    required this.uid,
    required this.hasAvatar,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(avatarProvider).isLoading;
    print(isLoading);

    return isLoading
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
        // : Container(
        //     width: 130,
        //     height: 130,
        //     decoration: BoxDecoration(
        //       shape: BoxShape.circle,
        //       border: Border.all(
        //         width: 1,
        //         color: Colors.grey.shade200,
        //       ),
        //       color: Colors.grey.shade200,
        //       image: DecorationImage(
        //         image: CachedNetworkImageProvider(
        //           "https://firebasestorage.googleapis.com/v0/b/do-it-now-a5725.appspot.com/o/avatars%2F$uid?alt=media&date=${DateTime.now().toString()}",
        //         ),
        //         fit: BoxFit.cover,
        //       ),
        //     ),
        //   );
        : CircleAvatar(
            radius: 65,
            foregroundColor: Colors.white,
            backgroundColor: Colors.grey.shade300,
            foregroundImage: hasAvatar
                ? NetworkImage(
                    "https://firebasestorage.googleapis.com/v0/b/do-it-now-a5725.appspot.com/o/avatars%2F$uid?alt=media&date=${DateTime.now().toString()}")
                : null,
            child: CircleAvatar(
              radius: 63,
              foregroundColor: Colors.grey.shade300,
              backgroundColor: Colors.white,
              child: const FaIcon(
                FontAwesomeIcons.user,
                size: 40,
              ),
            ),
          );
  }
}
