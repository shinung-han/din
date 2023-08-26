import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Avatar extends ConsumerWidget {
  final String name;
  final String avatarUrl;
  final String uid;
  final bool hasAvatar;

  const Avatar({
    super.key,
    required this.name,
    required this.avatarUrl,
    required this.uid,
    required this.hasAvatar,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return hasAvatar == true
        ? Container(
            width: 130,
            height: 130,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.grey.shade300,
                width: 2,
              ),
              image: DecorationImage(
                image: CachedNetworkImageProvider(avatarUrl),
                fit: BoxFit.cover,
              ),
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
            ),
            child: Center(
              child: Icon(
                Icons.person,
                color: Colors.grey.shade300,
                size: 50,
              ),
            ),
          );
  }
}
