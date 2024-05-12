import 'package:flutter/material.dart';
import 'package:healthsync_maybe/providers/nutrition_data_provider.dart';
import 'dart:math' as math;


class PieChartPainter extends CustomPainter {
  final double protein;
  final double carbs;
  final double fats;

  PieChartPainter(
      {required this.protein, required this.carbs, required this.fats});

  @override
  void paint(Canvas canvas, Size size) {
    final total = protein + carbs + fats;
    final radius = math.min(size.width, size.height) / 2;
    var startAngle = -math.pi / 2;

    void drawSegment(double value, Color color, String label) {
      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;

      final sweepAngle = (value / total) * 2 * math.pi;
      canvas.drawArc(
          Rect.fromCircle(center: Offset(radius, radius), radius: radius),
          startAngle,
          sweepAngle,
          true,
          paint);

      // Draw text label
      final textPainter = TextPainter(
        text: TextSpan(
          text:
              "$label ${(value / total * 100).toStringAsFixed(1)}%", // Label and percentage
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      final labelRadius =
          radius * 0.7; // Positioning the label inside the slice
      final labelTheta = startAngle + sweepAngle / 2;
      final labelX = radius + labelRadius * math.cos(labelTheta);
      final labelY = radius + labelRadius * math.sin(labelTheta);
      textPainter.paint(
          canvas,
          Offset(
              labelX - textPainter.width / 2, labelY - textPainter.height / 2));

      startAngle += sweepAngle;
    }

    drawSegment(protein, Colors.blue, "Protein");
    drawSegment(carbs, Colors.green, "Carbs");
    drawSegment(fats, Colors.red, "Fats");
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  _ProfileTabState createState() => _ProfileTabState();
}

class WorkoutData {
  final String day;
  int hours;

  WorkoutData({required this.day, required this.hours});
}

class BarChartPainter extends CustomPainter {
  final int hours; // Add a field to hold the number of hours

  BarChartPainter(this.hours); // Modify constructor to accept hours

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 5.0
      ..style = PaintingStyle.fill;

    // Draw the rectangle bar
    canvas.drawRect(Offset.zero & size, paint);

    // Draw text on the bar
    final textSpan = TextSpan(
      text: '$hours',
      style: const TextStyle(color: Colors.white, fontSize: 14),
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    textPainter.layout(
      minWidth: 0,
      maxWidth: size.width,
    );

    // Position the text in the center of the bar
    final xCenter = (size.width - textPainter.width) / 2;
    final yCenter = (size.height - textPainter.height) / 2;
    final offset = Offset(xCenter, yCenter);
    textPainter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // Always repaint for demo purposes
  }
}

@override
bool shouldRepaint(CustomPainter oldDelegate) {
  return false;
}

class _ProfileTabState extends State<ProfileTab> {
  final List<WorkoutData> workoutData = [];

  void _showInputDialog(BuildContext context) {
    final TextEditingController hoursController = TextEditingController();
    final TextEditingController dayController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Workout Data'),
          content: Column(
            mainAxisSize: MainAxisSize.min, // Adjusted for better UI handling
            children: <Widget>[
              TextField(
                controller: hoursController,
                decoration: const InputDecoration(hintText: 'Enter hours'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: dayController,
                decoration: const InputDecoration(
                    hintText: 'Enter day (3 letters only): Mon, Tue, ...'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                final String day = dayController.text.trim();
                final int hours = int.tryParse(hoursController.text) ?? 0;

                // Try to find existing data for the day
                int index = workoutData.indexWhere(
                    (data) => data.day.toLowerCase() == day.toLowerCase());

                if (index != -1) {
                  // Update existing data
                  workoutData[index].hours = hours;
                } else {
                  // Add new data entry
                  workoutData.add(WorkoutData(day: day, hours: hours));
                }

                setState(() {});
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // ...

  @override
  Widget build(BuildContext context) {
    final nutritionData = NutritionDataProvider.of(context);

    return Scaffold(
      backgroundColor: Colors.blue[100],
      appBar: AppBar(
        backgroundColor: Colors.blue[100],
        title: const Text(
          'User Profile',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // CircleAvatar and 'User' text
            const Column(
              children: [
                CircleAvatar(
                  radius: 60.0,
                  backgroundColor: Colors.blue,
                  child: Icon(
                    Icons.person,
                    size: 60.0,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10.0),
                Text(
                  'User',
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(
                height: 40.0), // Spacer between 'User' and widgets below

            // First widget: Macros Eaten Today
            SingleChildScrollView(
              child: _buildBorderedWidget(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Macros Eaten Today',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Protein: ${nutritionData.protein}g | Carbs: ${nutritionData.carbs}g | Fat: ${nutritionData.fats}g',
                      style:
                          const TextStyle(fontSize: 16.0, color: Colors.black),
                    ),
                    const SizedBox(height: 20.0),
                    SizedBox(
                      height: 200, // Set the height for the pie chart
                      width: 200, // Set the width for the pie chart
                      child: CustomPaint(
                        painter: PieChartPainter(
                          protein: nutritionData.protein.toDouble(),
                          carbs: nutritionData.carbs.toDouble(),
                          fats: nutritionData.fats.toDouble(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20.0), // Spacer between widgets

            // Second widget: Weekly Workout Hours
            SingleChildScrollView(
              child: _buildBorderedWidget(
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Weekly Workout Hours',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          _buildDayWorkoutBar('Mon'),
                          _buildDayWorkoutBar('Tue'),
                          _buildDayWorkoutBar('Wed'),
                          _buildDayWorkoutBar('Thu'),
                          _buildDayWorkoutBar('Fri'),
                          _buildDayWorkoutBar('Sat'),
                          _buildDayWorkoutBar('Sun'),
                        ],
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () => _showInputDialog(context),
                        child: const Text('Add Workout Data'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build a bordered widget
  Widget _buildBorderedWidget({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      margin: const EdgeInsets.symmetric(
          vertical: 8.0), // Adjust vertical margin as needed
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: child,
    );
  }

// Helper method to build workout hour bar for a specific day
  Widget _buildDayWorkoutBar(String day) {
    final int hours = workoutData
        .firstWhere((data) => data.day.toLowerCase() == day.toLowerCase(),
            orElse: () => WorkoutData(day: day, hours: 0))
        .hours;

    return CustomPaint(
      key: ValueKey(
          day + hours.toString()), // Ensures widget rebuilds when data changes
      size: Size(30, (hours * 10).toDouble()), // Convert hours to pixels
      painter: BarChartPainter(hours), // Pass hours to the painter
    );
  }
}
