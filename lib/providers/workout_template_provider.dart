import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:healthsync_maybe/providers/storage.dart';

class WorkoutTemplateProvider with ChangeNotifier {
  static const _key = 'workout_templates';
  final SharedPreferences _prefs;
  final List<List<Map<String, String>>> _existingWorkoutTemplates;

  WorkoutTemplateProvider(this._prefs)
      : _existingWorkoutTemplates = readJson(_prefs, _key, [],
            (json) => [for (final t in json as List) parseExercises(t)]);

  List<List<Map<String, String>>> get existingWorkoutTemplates =>
      _existingWorkoutTemplates;

  void addTemplate(List<Map<String, String>> newTemplate) {
    _existingWorkoutTemplates.add(newTemplate);
    _save();
  }

  void deleteTemplate(int index) {
    _existingWorkoutTemplates.removeAt(index);
    _save();
  }

  void _save() {
    writeJson(_prefs, _key, _existingWorkoutTemplates);
    notifyListeners();
  }
}
