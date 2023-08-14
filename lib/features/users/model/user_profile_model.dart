class UserProfileModel {
  final String uid;
  final String name;
  final String email;
  final String bio;
  final String link;
  final bool hasAvatar;
  final bool hasProject;
  final bool isLoading;

  UserProfileModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.bio,
    required this.link,
    required this.hasAvatar,
    required this.hasProject,
    required this.isLoading,
  });

  UserProfileModel.empty()
      : uid = "",
        name = "",
        email = "",
        bio = "",
        link = "",
        hasAvatar = false,
        hasProject = false,
        isLoading = false;

  UserProfileModel.fromJson(Map<String, dynamic> json)
      : uid = json["uid"],
        name = json["name"],
        email = json["email"],
        bio = json["bio"],
        link = json["link"],
        hasAvatar = json["hasAvatar"],
        hasProject = json["hasProject"],
        isLoading = json["isLoading"];

  Map<String, dynamic> toJson(String name) {
    return {
      "uid": uid,
      "name": name,
      "email": email,
      "bio": bio,
      "link": link,
      "hasAvatar": false,
      "hasProject": false,
      "isLoading": false,
    };
  }

  UserProfileModel copyWith({
    String? uid,
    String? name,
    String? email,
    String? bio,
    String? link,
    bool? hasAvatar,
    bool? hasProject,
    bool? isLoading,
  }) {
    return UserProfileModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      bio: bio ?? this.bio,
      link: link ?? this.link,
      hasAvatar: hasAvatar ?? this.hasAvatar,
      hasProject: hasProject ?? this.hasProject,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
