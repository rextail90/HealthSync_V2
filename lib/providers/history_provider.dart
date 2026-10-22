import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:healthsync_maybe/providers/storage.dart';

class ExerciseHistoryProvider with ChangeNotifier {
  static const _key = 'workout_history';
  final SharedPreferences _prefs;
  final List<Map<String, dynamic>> _completedSessions;

  ExerciseHistoryProvider(this._prefs)
      : _completedSessions = readJson(
            _prefs,
            _key,
            [],
            (json) => [
                  for (final s in json as List)
                    {
                      'date': s['date'] as String,
                      'duration': s['duration'] as String,
                      'exercises': parseExercises(s['exercises']),
                    }
                ]);

  List<Map<String, dynamic>> get completedSessions => _completedSessions;

  void addCompletedSession(
      String duration, List<Map<String, String>> exercises) {
    _completedSessions.add({
      'date': DateTime.now().toIso8601String(),
      'duration': duration,
      'exercises': exercises,
    });
    writeJson(_prefs, _key, _completedSessions);
    notifyListeners();
  }
}
