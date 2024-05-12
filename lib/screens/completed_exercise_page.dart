import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:healthsync_maybe/providers/timer_provider.dart';

class CompletedExercisesPage extends StatelessWidget {
  final String duration;
  final List<Map<String, String>> completedExercises;

  const CompletedExercisesPage({super.key, required this.duration, required this.completedExercises});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Completed Exercises'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Provider.of<TimerProvider>(context, listen: false).reset(); // Resets the timer when navigating back
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Great Job Finishing Your Exercise!', style: Theme.of(context).textTheme.headlineSmall),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Duration: $duration', style: Theme.of(context).textTheme.titleLarge),
          ),
          const Text('Here are your stats:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Expanded(
            child: ListView.builder(
              itemCount: completedExercises.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(completedExercises[index]['name'] ?? 'No Name'),
                  subtitle: Text('Sets: ${completedExercises[index]['sets']}, Reps: ${completedExercises[index]['reps']}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
