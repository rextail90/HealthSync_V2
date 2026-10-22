import 'dart:async';
import 'package:flutter/foundation.dart';

class TimerProvider with ChangeNotifier {
  TimerProvider({DateTime Function()? now}) : _now = now ?? DateTime.now;

  final DateTime Function() _now;
  Timer? _ticker;
  DateTime? _startedAt;

  bool get isRunning => _startedAt != null;

  // Measured from the wall clock, so it keeps counting while the phone is
  // locked or the browser tab is in the background.
  Duration get duration =>
      _startedAt == null ? Duration.zero : _now().difference(_startedAt!);

  void start() {
    if (isRunning) return;
    _startedAt = _now();
    // The ticker only triggers repaints; it doesn't keep time.
    _ticker =
        Timer.periodic(const Duration(seconds: 1), (_) => notifyListeners());
    notifyListeners();
  }

  void reset() {
    _ticker?.cancel();
    _ticker = null;
    _startedAt = null;
    notifyListeners();
  }

  String get durationString {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final d = duration;
    return '${twoDigits(d.inHours)}:${twoDigits(d.inMinutes.remainder(60))}'
        ':${twoDigits(d.inSeconds.remainder(60))}';
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }
}
