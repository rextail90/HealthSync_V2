import 'package:flutter/material.dart';
import 'dart:math' as math;

class NutritionTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nutrition'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Enter Nutrition Data:',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 20.0),
            NutritionForm(),
          ],
        ),
      ),
    );
  }
}

class NutritionForm extends StatefulWidget {
  @override
  _NutritionFormState createState() => _NutritionFormState();
}

class _NutritionFormState extends State<NutritionForm> {
  TextEditingController carbsController = TextEditingController();
  TextEditingController proteinController = TextEditingController();
  TextEditingController fatController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TextFormField(
          controller: carbsController,
          decoration: InputDecoration(labelText: 'Carbohydrates'),
          keyboardType: TextInputType.number,
        ),
        TextFormField(
          controller: proteinController,
          decoration: InputDecoration(labelText: 'Protein'),
          keyboardType: TextInputType.number,
        ),
        TextFormField(
          controller: fatController,
          decoration: InputDecoration(labelText: 'Fat'),
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 20.0),
        ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                content: Container(
                  width: 300,
                  height: 300,
                  child: PieChart(
                    carbs: double.parse(carbsController.text),
                    protein: double.parse(proteinController.text),
                    fat: double.parse(fatController.text),
                  ),
                ),
              ),
            );
          },
          child: Text('Generate Pie Chart'),
        ),
      ],
    );
  }
}

class PieChart extends StatelessWidget {
  final double carbs;
  final double protein;
  final double fat;

  const PieChart(
      {required this.carbs, required this.protein, required this.fat});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(300, 300),
      painter: PieChartPainter(carbs, protein, fat),
    );
  }
}

class PieChartPainter extends CustomPainter {
  final double carbs;
  final double protein;
  final double fat;

  PieChartPainter(this.carbs, this.protein, this.fat);

  @override
  void paint(Canvas canvas, Size size) {
    double total = carbs + protein + fat;
    double carbsAngle = (carbs / total) * 2 * math.pi;
    double proteinAngle = (protein / total) * 2 * math.pi;
    double fatAngle = (fat / total) * 2 * math.pi;

    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = size.width / 2;
    Paint paint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.blue;

    // Draw Carbs segment
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      carbsAngle,
      true,
      paint,
    );
    _drawLabel(canvas, center, radius, -math.pi / 2, carbsAngle, "Carbs",
        carbs / total);

    paint.color = Colors.green;

    // Draw Protein segment
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2 + carbsAngle,
      proteinAngle,
      true,
      paint,
    );
    _drawLabel(canvas, center, radius, -math.pi / 2 + carbsAngle, proteinAngle,
        "Protein", protein / total);

    paint.color = Colors.orange;

    // Draw Fat segment
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2 + carbsAngle + proteinAngle,
      fatAngle,
      true,
      paint,
    );
    _drawLabel(canvas, center, radius, -math.pi / 2 + carbsAngle + proteinAngle,
        fatAngle, "Fat", fat / total);
  }

  void _drawLabel(Canvas canvas, Offset center, double radius,
      double startAngle, double sweepAngle, String label, double percentage) {
    // Calculate label position
    double labelRadius = radius * 0.7;
    double labelAngle = startAngle + sweepAngle / 2;
    double x = center.dx + labelRadius * math.cos(labelAngle);
    double y = center.dy + labelRadius * math.sin(labelAngle);

    // Draw label
    TextSpan span = TextSpan(
      style: TextStyle(color: Colors.black, fontSize: 14.0),
      text: '$label\n(${(percentage * 100).toStringAsFixed(1)}%)',
    );
    TextPainter tp = TextPainter(
      text: span,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    tp.layout();
    tp.paint(canvas, Offset(x - tp.width / 2, y - tp.height / 2));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
