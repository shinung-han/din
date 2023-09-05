import 'dart:io';

class GoalModel {
  final int id;
  String title;
  File? image;
  final DateTime? date;
  String? imageUrl;

  GoalModel({
    required this.id,
    required this.title,
    this.image,
    this.date,
    this.imageUrl,
  });

  GoalModel copyWith({
    int? id,
    String? title,
  }) {
    return GoalModel(id: id ?? this.id, title: title ?? this.title);
  }

  void changeTitle(String newTitle) {
    title = newTitle;
  }

  void updateImage(File newImage) {
    image = newImage;
  }
}
