import 'package:flutter/material.dart';
import 'package:healthsync_maybe/providers/history_provider.dart';
import 'package:provider/provider.dart';

class HistoryTab extends StatelessWidget {
  const HistoryTab({super.key});

  @override
  Widget build(BuildContext context) {
    final sessions = context.watch<ExerciseHistoryProvider>().completedSessions;

    return Scaffold(
      appBar: AppBar(title: const Text("Exercise History")),
      body: ListView.builder(
        itemCount: sessions.length,
        itemBuilder: (context, index) {
          final session = sessions[sessions.length - 1 - index]; // newest first
          final date = DateTime.parse(session['date'] as String);
          final exercises = session['exercises'] as List<Map<String, String>>;
          return ExpansionTile(
            title: Text("Worked out for ${session['duration']}"),
            subtitle: Text('${date.month}/${date.day}/${date.year}'),
            children: [
              for (final exercise in exercises)
                ListTile(
                  title: Text(exercise['name'] ?? 'No Name'),
                  subtitle: Text(
                      'Sets: ${exercise['sets']}, Reps: ${exercise['reps']}'),
                ),
            ],
          );
        },
      ),
    );
  }
}
