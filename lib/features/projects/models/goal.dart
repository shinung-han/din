import 'package:flutter/material.dart';

class Goal {
  final String id;
  final String title;
  final Image? image;

  Goal({
    required this.id,
    required this.title,
    this.image,
  });
}
