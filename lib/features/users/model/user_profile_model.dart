import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfileModel {
  final String uid;
  final String name;
  final String email;
  final String bio;
  final String link;
  final bool hasAvatar;
  final String avatarUrl;
  final bool hasProject;
  final bool isLoading;
  final DateTime? startDate;

  UserProfileModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.bio,
    required this.link,
    required this.hasAvatar,
    required this.avatarUrl,
    required this.hasProject,
    required this.isLoading,
    this.startDate,
  });

  UserProfileModel.empty()
      : uid = "",
        name = "",
        email = "",
        bio = "",
        link = "",
        hasAvatar = false,
        avatarUrl = "",
        hasProject = false,
        isLoading = false,
        startDate = DateTime.now();

  UserProfileModel.fromJson(Map<String, dynamic> json)
      : uid = json["uid"],
        name = json["name"],
        email = json["email"],
        bio = json["bio"],
        link = json["link"],
        hasAvatar = json["hasAvatar"],
        avatarUrl = json["avatarUrl"],
        hasProject = json["hasProject"],
        isLoading = json["isLoading"],
        startDate = (json["startDate"] as Timestamp?)?.toDate();

  Map<String, dynamic> toJson(String name) {
    return {
      "uid": uid,
      "name": name,
      "email": email,
      "bio": bio,
      "link": link,
      "hasAvatar": false,
      "avatarUrl": avatarUrl,
      "hasProject": false,
      "isLoading": false,
      "startDate": startDate,
    };
  }

  UserProfileModel copyWith({
    String? uid,
    String? name,
    String? email,
    String? bio,
    String? link,
    bool? hasAvatar,
    String? avatarUrl,
    bool? hasProject,
    bool? isLoading,
    DateTime? startDate,
  }) {
    return UserProfileModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      bio: bio ?? this.bio,
      link: link ?? this.link,
      hasAvatar: hasAvatar ?? this.hasAvatar,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      hasProject: hasProject ?? this.hasProject,
      isLoading: isLoading ?? this.isLoading,
      startDate: startDate ?? this.startDate,
    );
  }
}
