import 'package:flutter/material.dart';

class ExerciseHistoryProvider with ChangeNotifier {
  final List<Map<String, dynamic>> _completedSessions = [];

  List<Map<String, dynamic>> get completedSessions => _completedSessions;

  void addCompletedSession(
      String duration, List<Map<String, String>> exercises) {
    _completedSessions.add({
      'duration': duration,
      'exercises': exercises,
    });
    notifyListeners();
  }
}
