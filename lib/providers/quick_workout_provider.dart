import 'package:flutter/material.dart';

class QuickWorkoutProvider with ChangeNotifier {
  List<Map<String, String>> _exercises = [];

  List<Map<String, String>> get exercises => _exercises;

  void addExercise(Map<String, String> exercise) {
    _exercises.add(exercise);
    notifyListeners();
  }

  void removeExercise(int index) {
    _exercises.removeAt(index);
    notifyListeners();
  }
}