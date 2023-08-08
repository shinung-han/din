import 'dart:io';

class GoalModel {
  final int id;
  String title;
  File? image;

  GoalModel({
    required this.id,
    required this.title,
    this.image,
  });

  void changeTitle(String newTitle) {
    title = newTitle;
  }

  void updateImage(File newImage) {
    image = newImage;
  }
}
