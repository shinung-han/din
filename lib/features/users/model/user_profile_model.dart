class UserProfileModel {
  final String uid;
  final String name;
  final String email;
  final String bio;
  final String link;
  final bool hasAvatar;

  UserProfileModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.bio,
    required this.link,
    required this.hasAvatar,
  });

  UserProfileModel.empty()
      : uid = "",
        name = "",
        email = "",
        bio = "",
        link = "",
        hasAvatar = false;

  UserProfileModel.fromJson(Map<String, dynamic> json)
      : uid = json["uid"],
        name = json["name"],
        email = json["email"],
        bio = json["bio"],
        link = json["link"],
        hasAvatar = json["hasAvatar"];

  Map<String, String> toJson() {
    return {
      "uid": uid,
      "name": name,
      "email": email,
      "bio": bio,
      "link": link,
    };
  }

  UserProfileModel copyWith({
    String? uid,
    String? name,
    String? email,
    String? bio,
    String? link,
    bool? hasAvatar,
  }) {
    return UserProfileModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      bio: bio ?? this.bio,
      link: link ?? this.link,
      hasAvatar: hasAvatar ?? this.hasAvatar,
    );
  }
}
