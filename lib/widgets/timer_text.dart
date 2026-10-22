import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:healthsync_maybe/providers/timer_provider.dart';

/// The running workout time. Only this text rebuilds on each tick, not the
/// screen around it.
class TimerText extends StatelessWidget {
  final TextStyle? style;

  const TimerText({super.key, this.style});

  @override
  Widget build(BuildContext context) =>
      Text(context.select<TimerProvider, String>((t) => t.durationString),
          style: style);
}
