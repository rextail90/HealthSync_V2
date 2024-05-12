import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:healthsync_maybe/providers/timer_provider.dart';
import 'package:healthsync_maybe/screens/completed_exercise_page.dart';

class TemplateWorkoutPage extends StatefulWidget {
  final List<Map<String, String>> template;
  const TemplateWorkoutPage({super.key, required this.template});

  @override
  _TemplateWorkoutPageState createState() => _TemplateWorkoutPageState();
}

class _TemplateWorkoutPageState extends State<TemplateWorkoutPage> {
  final List<Map<String, String>> _completedExercises = [];

  @override
  void initState() {
    super.initState();
    Provider.of<TimerProvider>(context, listen: false).start();
  }
  
  @override
  Widget build(BuildContext context) {
    TimerProvider timerProvider = Provider.of<TimerProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Current Workout'),
            Text(timerProvider.durationString),  // Display the current time from the TimerProvider
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              timerProvider.stop();  // Stop the timer
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CompletedExercisesPage(
                    duration: timerProvider.durationString,
                    completedExercises: _completedExercises,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: widget.template.length,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: _completedExercises.contains(widget.template[index]) ? Colors.green : Colors.grey,
              ),
            ),
            child: ListTile(
              title: Text(widget.template[index]['name'] ?? 'No Name'),
              trailing: IconButton(
                icon: const Icon(Icons.check),
                onPressed: () {
                  setState(() {
                    if (!_completedExercises.contains(widget.template[index])) {
                      _completedExercises.add(widget.template[index]);
                    }
                  });
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
