import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class TimerProvider extends ChangeNotifier {
  late Timer _timer;
  Duration _duration = Duration.zero;

  String get durationString => _formatDuration(_duration);

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _duration += const Duration(seconds: 1);
      notifyListeners();
    });
  }

  void stopTimer() {
    _timer.cancel();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }
}