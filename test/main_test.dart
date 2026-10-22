import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:healthsync_maybe/providers/history_provider.dart';
import 'package:healthsync_maybe/providers/nutrition_data_provider.dart';
import 'package:healthsync_maybe/providers/timer_provider.dart';
import 'package:healthsync_maybe/providers/workout_template_provider.dart';

Future<SharedPreferences> prefsWith(Map<String, Object> values) {
  SharedPreferences.setMockInitialValues(values);
  return SharedPreferences.getInstance();
}

void main() {
  test('TimerProvider tracks wall-clock time, formats and resets', () {
    var now = DateTime(2024, 5, 10, 9);
    final timer = TimerProvider(now: () => now);
    expect(timer.durationString, '00:00:00');

    timer.start();
    // No ticks fire here, like a locked phone; time must still pass.
    now = now.add(const Duration(seconds: 3661));
    expect(timer.isRunning, isTrue);
    expect(timer.durationString, '01:01:01');

    timer.reset();
    expect(timer.isRunning, isFalse);
    expect(timer.durationString, '00:00:00');
    timer.dispose();
  });

  test('NutritionDataProvider notifies, saves and reloads today\'s macros',
      () async {
    final prefs = await prefsWith({});
    final provider = NutritionDataProvider(prefs);
    var notified = 0;
    provider.addListener(() => notified++);

    provider.update(120, 250, 60);

    expect(notified, 1);
    final reloaded = NutritionDataProvider(prefs).data;
    expect([reloaded.protein, reloaded.carbs, reloaded.fats], [120, 250, 60]);
  });

  test('Macros saved on an earlier day load as zeros', () async {
    final prefs = await prefsWith({
      'nutrition_today': '{"date":"2000-01-01","protein":1,"carbs":2,"fats":3}',
    });
    expect(NutritionDataProvider(prefs).data.protein, 0);
  });

  test('Templates and history survive an app restart', () async {
    final prefs = await prefsWith({});
    final bench = {'name': 'Bench', 'sets': '4', 'reps': '8'};
    WorkoutTemplateProvider(prefs).addTemplate([bench]);
    ExerciseHistoryProvider(prefs).addCompletedSession('00:30:00', [bench]);

    expect(WorkoutTemplateProvider(prefs).existingWorkoutTemplates, [
      [bench]
    ]);
    final session = ExerciseHistoryProvider(prefs).completedSessions.single;
    expect(session['duration'], '00:30:00');
    expect(session['exercises'], [bench]);
  });

  test('Corrupt saved data falls back to empty instead of crashing', () async {
    final prefs = await prefsWith({
      'workout_templates': 'not json',
      'workout_history': '[{"oops": true}]',
    });
    expect(WorkoutTemplateProvider(prefs).existingWorkoutTemplates, isEmpty);
    expect(ExerciseHistoryProvider(prefs).completedSessions, isEmpty);
  });
}
