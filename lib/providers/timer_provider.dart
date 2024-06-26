import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class TimerProvider with ChangeNotifier {
  Timer? _timer;
  Duration _duration = Duration.zero;
  bool _isRunning = false; // Indicates if the timer is running

  bool get isRunning => _isRunning;

  void start() {
    if (_timer != null && _timer!.isActive) return;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _duration += const Duration(seconds: 1);
      notifyListeners();
    });
    _isRunning = true;
    notifyListeners();
  }

  void stop() {
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
      _isRunning = false;
      notifyListeners();
    }
  }

  void reset() {
    stop();
    _duration = Duration.zero;
    notifyListeners();
  }

  Duration get duration => _duration;

  String get durationString {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(_duration.inHours);
    final minutes = twoDigits(_duration.inMinutes.remainder(60));
    final seconds = twoDigits(_duration.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }
}
