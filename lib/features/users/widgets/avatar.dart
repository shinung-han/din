import 'package:cached_network_image/cached_network_image.dart';
import 'package:din/features/users/view_models/avatar_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
        : Container(
            width: 130,
            height: 130,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              shape: BoxShape.circle,

              border: Border.all(
                color: Colors.grey.shade300,
                width: 2,
              ),
              // borderRadius: BorderRadius.circular(radius)
            ),
            child: hasAvatar
                ? Image(
                    image: CachedNetworkImageProvider(
                        "https://firebasestorage.googleapis.com/v0/b/do-it-now-a5725.appspot.com/o/avatars%2F$uid?alt=media&date=${DateTime.now().toString()}"),
                  )
                : Center(
                    child: Icon(
                      Icons.person,
                      color: Colors.grey.shade300,
                      size: 50,
                    ),
                  ),
          );
  }
}
