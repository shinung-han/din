import 'package:din/features/projects/list_of_goals_screen.dart';
import 'package:din/features/projects/models/goal_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GoalListViewModel extends StateNotifier<List<GoalModel>> {
  GoalListViewModel() : super([]);

  void addGoal(GoalModel goal) {
    state = [...state, goal];
  }

  void deleteGoal(BuildContext context, int id) {
    state = state.where((goal) => goal.id != id).toList();
    Navigator.popUntil(
        context, ModalRoute.withName(ListOfGoalsScreen.routeURL));
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
}

final goalListProvider =
    StateNotifierProvider<GoalListViewModel, List<GoalModel>>(
  (ref) => GoalListViewModel(),
);
