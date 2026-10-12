import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:healthsync_maybe/providers/quick_workout_provider.dart';
import 'package:healthsync_maybe/providers/timer_provider.dart';
import 'package:healthsync_maybe/screens/completed_exercise_page.dart';
import 'package:healthsync_maybe/widgets/add_exercise_dialog.dart';

class QuickWorkoutPage extends StatefulWidget {
  const QuickWorkoutPage({super.key});

  @override
  State<QuickWorkoutPage> createState() => _QuickWorkoutPageState();
}

class _QuickWorkoutPageState extends State<QuickWorkoutPage> {
  final List<Map<String, String>> _completedExercises = [];

  @override
  void initState() {
    super.initState();
    context.read<TimerProvider>().start();
  }

  Future<void> _addExercise() async {
    final exercise = await showAddExerciseDialog(context);
    if (exercise != null && mounted) {
      context.read<QuickWorkoutProvider>().addExercise(exercise);
    }
  }

  @override
  Widget build(BuildContext context) {
    final timerProvider = context.watch<TimerProvider>();
    final quickWorkoutProvider = context.watch<QuickWorkoutProvider>();
    final exercises = quickWorkoutProvider.exercises;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quick Workout'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () => finishWorkout(context, _completedExercises),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Text(timerProvider.durationString,
              style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              timerProvider.reset();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
            child: const Text('Cancel Workout'),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: exercises.length,
              itemBuilder: (context, index) {
                final exercise = exercises[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  elevation: 2,
                  child: ListTile(
                    title: Text(exercise['name'] ?? 'No Name'),
                    subtitle: Text(
                        'Sets: ${exercise['sets']}, Reps: ${exercise['reps']}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.check, color: Colors.green),
                          onPressed: () {
                            _completedExercises.add(exercise);
                            quickWorkoutProvider.removeExercise(index);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () =>
                              quickWorkoutProvider.removeExercise(index),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addExercise,
        child: const Icon(Icons.add),
      ),
    );
  }
}
