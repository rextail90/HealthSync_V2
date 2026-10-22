import 'package:flutter_test/flutter_test.dart';
import 'package:healthsync_maybe/providers/nutrition_data_provider.dart';
import 'package:healthsync_maybe/providers/timer_provider.dart';

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

  test('NutritionDataProvider notifies listeners on update', () {
    final provider = NutritionDataProvider();
    var notified = 0;
    provider.addListener(() => notified++);

    provider.update(120, 250, 60);

    expect(notified, 1);
    expect(provider.data.protein, 120);
    expect(provider.data.carbs, 250);
    expect(provider.data.fats, 60);
  });
}
