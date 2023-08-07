import 'dart:io';

class GoalModel {
  final int id;
  String title;
  final File? image;

  GoalModel({
    required this.id,
    required this.title,
    this.image,
  });

  void changeTitle(String newTitle) {
    title = newTitle;
  }
}
