import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:healthsync_maybe/providers/timer_provider.dart';
import 'package:healthsync_maybe/screens/completed_exercise_page.dart';
import 'package:healthsync_maybe/widgets/timer_text.dart';

class TemplateWorkoutPage extends StatefulWidget {
  final List<Map<String, String>> template;
  const TemplateWorkoutPage({super.key, required this.template});

  @override
  State<TemplateWorkoutPage> createState() => _TemplateWorkoutPageState();
}

class _TemplateWorkoutPageState extends State<TemplateWorkoutPage> {
  final List<Map<String, String>> _completedExercises = [];

  @override
  void initState() {
    super.initState();
    context.read<TimerProvider>().start();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text('Current Workout'), TimerText()],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () => finishWorkout(context, _completedExercises),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: widget.template.length,
        itemBuilder: (context, index) {
          final exercise = widget.template[index];
          final done = _completedExercises.contains(exercise);
          return Container(
            decoration: BoxDecoration(
              border: Border.all(color: done ? Colors.green : Colors.grey),
            ),
            child: ListTile(
              tileColor: done ? Colors.green[100] : null,
              title: Text(exercise['name'] ?? 'No Name'),
              subtitle:
                  Text('Sets: ${exercise['sets']}, Reps: ${exercise['reps']}'),
              trailing: IconButton(
                icon: Icon(done ? Icons.check_circle : Icons.check),
                disabledColor: Colors.green,
                onPressed: done
                    ? null
                    : () => setState(() => _completedExercises.add(exercise)),
              ),
            ),
          );
        },
      ),
    );
  }
}
