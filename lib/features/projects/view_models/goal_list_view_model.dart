import 'dart:io';

import 'package:din/features/projects/models/goal_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GoalListViewModel extends StateNotifier<List<GoalModel>> {
  GoalListViewModel() : super([]);

  void addGoal(GoalModel goal) {
    state = [...state, goal];
  }

  void deleteGoal(int id) {
    state = state.where((goal) => goal.id != id).toList();
  }

  void deleteAllGoals(BuildContext context) {
    state = [];
    Navigator.pop(context);
  }

  void changeGoalTitle(int goalId, String newTitle) {
    state = state.map((goal) {
      if (goal.id == goalId) {
        goal.changeTitle(newTitle);
      }
      return goal;
    }).toList();
  }

  void updateGoalImage(int goalId, File newImage) {
    final goal = state.firstWhere((goal) => goal.id == goalId);
    goal.updateImage(newImage);
    state = [...state];
  }

  void loadGoalsOfToday(String uid) {}
}

final goalListProvider =
    StateNotifierProvider<GoalListViewModel, List<GoalModel>>(
  (ref) => GoalListViewModel(),
);
