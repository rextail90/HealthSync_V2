import 'package:flutter/material.dart';

class CompletedExercisesPage extends StatelessWidget {
  final String duration;
  final List<Map<String, String>> completedExercises;

  const CompletedExercisesPage({Key? key, required this.duration, required this.completedExercises}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Completed Exercises'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Great Job Finishing Your Exercise!', style: Theme.of(context).textTheme.headline5),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Duration: $duration', style: Theme.of(context).textTheme.headline6),
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
