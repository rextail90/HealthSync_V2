import 'package:flutter/material.dart';
import 'package:healthsync_maybe/providers/history_provider.dart';
import 'package:provider/provider.dart';
import 'package:healthsync_maybe/providers/timer_provider.dart';

/// Saves the session to history, resets the timer, and shows the summary.
void finishWorkout(BuildContext context, List<Map<String, String>> completed) {
  final timer = context.read<TimerProvider>();
  final duration = timer.durationString;
  context
      .read<ExerciseHistoryProvider>()
      .addCompletedSession(duration, completed);
  timer.reset();
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (_) => CompletedExercisesPage(
          duration: duration, completedExercises: completed),
    ),
  );
}

class CompletedExercisesPage extends StatelessWidget {
  final String duration;
  final List<Map<String, String>> completedExercises;

  const CompletedExercisesPage(
      {super.key, required this.duration, required this.completedExercises});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Completed Exercises')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Great Job Finishing Your Exercise!',
                style: Theme.of(context).textTheme.headlineSmall),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Duration: $duration',
                style: Theme.of(context).textTheme.titleLarge),
          ),
          const Text('Here are your stats:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Expanded(
            child: ListView.builder(
              itemCount: completedExercises.length,
              itemBuilder: (context, index) {
                final exercise = completedExercises[index];
                return ListTile(
                  title: Text(exercise['name'] ?? 'No Name'),
                  subtitle: Text(
                      'Sets: ${exercise['sets']}, Reps: ${exercise['reps']}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
