import 'dart:math' as math;
import 'package:flutter/foundation.dart' show listEquals;
import 'package:flutter/material.dart';

typedef PieSlice = ({double value, Color color, String label});

class MacroPieChart extends StatelessWidget {
  final List<PieSlice> slices;
  final double size;

  const MacroPieChart({super.key, required this.slices, this.size = 200});

  @override
  Widget build(BuildContext context) => SizedBox.square(
      dimension: size, child: CustomPaint(painter: _PiePainter(slices)));
}

class _PiePainter extends CustomPainter {
  final List<PieSlice> slices;

  _PiePainter(this.slices);

  @override
  void paint(Canvas canvas, Size size) {
    final total = slices.fold<double>(0, (sum, s) => sum + s.value);
    if (total <= 0) return; // nothing logged yet; avoids NaN angles
    final radius = math.min(size.width, size.height) / 2;
    final center = size.center(Offset.zero);
    var start = -math.pi / 2;

    for (final s in slices) {
      if (s.value <= 0) continue;
      final sweep = s.value / total * 2 * math.pi;
      canvas.drawArc(Rect.fromCircle(center: center, radius: radius), start,
          sweep, true, Paint()..color = s.color);

      final tp = TextPainter(
        text: TextSpan(
          text: s.label,
          style: const TextStyle(
              color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
        ),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      )..layout();
      final mid = start + sweep / 2;
      tp.paint(
          canvas,
          center +
              Offset(math.cos(mid), math.sin(mid)) * radius * 0.6 -
              Offset(tp.width / 2, tp.height / 2));
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(_PiePainter oldDelegate) =>
      !listEquals(oldDelegate.slices, slices);
}
