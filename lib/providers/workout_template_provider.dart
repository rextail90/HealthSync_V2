import 'package:flutter/foundation.dart';

class WorkoutTemplateProvider with ChangeNotifier {
  final List<List<Map<String, String>>> _existingWorkoutTemplates = [];

  List<List<Map<String, String>>> get existingWorkoutTemplates => _existingWorkoutTemplates;

  void addTemplate(List<Map<String, String>> newTemplate) {
    _existingWorkoutTemplates.add(newTemplate);
    notifyListeners();
  }

  void deleteTemplate(int index) {
  _existingWorkoutTemplates.removeAt(index);
  notifyListeners();
}

void updateTemplate(int index, List<Map<String, String>> newTemplate) {
  _existingWorkoutTemplates[index] = newTemplate;
  notifyListeners();
}
}