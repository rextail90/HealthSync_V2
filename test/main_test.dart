import 'package:flutter_test/flutter_test.dart';
import 'package:healthsync_maybe/providers/nutrition_data_provider.dart';
import 'package:healthsync_maybe/providers/timer_provider.dart';

void main() {
  // testWidgets runs in fake async, so pump() advances Timer.periodic.
  testWidgets('TimerProvider counts, formats and resets', (tester) async {
    final timer = TimerProvider();
    expect(timer.durationString, '00:00:00');

    timer.start();
    await tester.pump(const Duration(seconds: 3661));
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
