import 'dart:io';

class GoalModel {
  final int id;
  String title;
  File? image;
  final DateTime? date;

  GoalModel({
    required this.id,
    required this.title,
    this.image,
    this.date,
  });

  void changeTitle(String newTitle) {
    title = newTitle;
  }

  void updateImage(File newImage) {
    image = newImage;
  }
}
