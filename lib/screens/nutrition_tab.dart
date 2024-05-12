import 'package:flutter/material.dart';
import 'dart:math' as math;

class NutritionTab extends StatelessWidget {
  const NutritionTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[100],
        title: const Text('Nutrition'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
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
  const NutritionForm({super.key});

  @override
  _NutritionFormState createState() => _NutritionFormState();
}

class _NutritionFormState extends State<NutritionForm> {
  TextEditingController carbsController = TextEditingController();
  TextEditingController proteinController = TextEditingController();
  TextEditingController fatController = TextEditingController();
  TextEditingController carbGoalController = TextEditingController();
  TextEditingController proteinGoalController = TextEditingController();
  TextEditingController fatGoalController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TextFormField(
          controller: carbsController,
          decoration: const InputDecoration(labelText: 'Carbohydrates'),
          keyboardType: TextInputType.number,
        ),
        TextFormField(
          controller: proteinController,
          decoration: const InputDecoration(labelText: 'Protein'),
          keyboardType: TextInputType.number,
        ),
        TextFormField(
          controller: fatController,
          decoration: const InputDecoration(labelText: 'Fat'),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 20.0),
        const Text('Enter Your Goals:'),
        TextFormField(
          controller: carbGoalController,
          decoration: const InputDecoration(labelText: 'Carbohydrates Goal'),
          keyboardType: TextInputType.number,
        ),
        TextFormField(
          controller: proteinGoalController,
          decoration: const InputDecoration(labelText: 'Protein Goal'),
          keyboardType: TextInputType.number,
        ),
        TextFormField(
          controller: fatGoalController,
          decoration: const InputDecoration(labelText: 'Fat Goal'),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 20.0),
        ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                content: SizedBox(
                  width: 300,
                  height: 300,
                  child: PieChart(
                    carbs: double.parse(carbsController.text),
                    protein: double.parse(proteinController.text),
                    fat: double.parse(fatController.text),
                    carbGoal: double.parse(carbGoalController.text),
                    proteinGoal: double.parse(proteinGoalController.text),
                    fatGoal: double.parse(fatGoalController.text),
                  ),
                ),
              ),
            );
          },
          child: const Text('Generate Pie Chart'),
        ),
      ],
    );
  }
}

class PieChart extends StatelessWidget {
  final double carbs;
  final double protein;
  final double fat;
  final double carbGoal;
  final double proteinGoal;
  final double fatGoal;

  const PieChart({super.key, 
    required this.carbs,
    required this.protein,
    required this.fat,
    required this.carbGoal,
    required this.proteinGoal,
    required this.fatGoal,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomPaint(
          size: const Size(300, 300),
          painter: PieChartPainter(
            carbs: carbs,
            protein: protein,
            fat: fat,
            carbGoal: carbGoal,
            proteinGoal: proteinGoal,
            fatGoal: fatGoal,
          ),
        ),
        const Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Center(
            child: Text(
              'Goals Met',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class PieChartPainter extends CustomPainter {
  final double carbs;
  final double protein;
  final double fat;
  final double carbGoal;
  final double proteinGoal;
  final double fatGoal;

  PieChartPainter({
    required this.carbs,
    required this.protein,
    required this.fat,
    required this.carbGoal,
    required this.proteinGoal,
    required this.fatGoal,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Calculate segment angles
    double total = carbs + protein + fat;
    double carbsAngle = (carbs / total) * 2 * math.pi;
    double proteinAngle = (protein / total) * 2 * math.pi;
    double fatAngle = (fat / total) * 2 * math.pi;

    // Draw actual nutrition segments
    _drawSegment(
      canvas,
      size,
      carbsAngle,
      proteinAngle,
      fatAngle,
      Colors.blue,
      Colors.green,
      Colors.orange,
      "Carbs (${(carbs / carbGoal * 100).toStringAsFixed(1)}%)",
      "Protein (${(protein / proteinGoal * 100).toStringAsFixed(1)}%)",
      "Fat (${(fat / fatGoal * 100).toStringAsFixed(1)}%)",
    );
  }

  void _drawSegment(
    Canvas canvas,
    Size size,
    double carbsAngle,
    double proteinAngle,
    double fatAngle,
    Color carbsColor,
    Color proteinColor,
    Color fatColor,
    String carbsLabel,
    String proteinLabel,
    String fatLabel,
  ) {
    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = size.width / 2;

    // Draw Carbs segment
    _drawArc(
      canvas,
      center,
      radius,
      -math.pi / 2,
      carbsAngle,
      carbsColor,
      carbsLabel,
    );

    // Draw Protein segment
    _drawArc(
      canvas,
      center,
      radius,
      -math.pi / 2 + carbsAngle,
      proteinAngle,
      proteinColor,
      proteinLabel,
    );

    // Draw Fat segment
    _drawArc(
      canvas,
      center,
      radius,
      -math.pi / 2 + carbsAngle + proteinAngle,
      fatAngle,
      fatColor,
      fatLabel,
    );
  }

  void _drawArc(
    Canvas canvas,
    Offset center,
    double radius,
    double startAngle,
    double sweepAngle,
    Color color,
    String label,
  ) {
    Paint paint = Paint()
      ..style = PaintingStyle.fill
      ..color = color;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      true,
      paint,
    );

    // Draw label
    final double labelRadius = radius * 0.7;
    final double labelAngle = startAngle + sweepAngle / 2;
    final double labelX = center.dx + labelRadius * math.cos(labelAngle);
    final double labelY = center.dy + labelRadius * math.sin(labelAngle);
    final TextSpan span = TextSpan(
      style: const TextStyle(
          color: Colors.black, fontSize: 14.0, fontWeight: FontWeight.bold),
      text: label,
    );
    final TextPainter tp = TextPainter(
      text: span,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    tp.layout();
    tp.paint(canvas, Offset(labelX - tp.width / 2, labelY - tp.height / 2));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: NutritionTab(),
  ));
}