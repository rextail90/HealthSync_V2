import 'package:flutter/material.dart';
import 'package:healthsync_maybe/providers/history_provider.dart';
import 'package:provider/provider.dart';

class HistoryTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> sessions =
        Provider.of<ExerciseHistoryProvider>(context).completedSessions;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Exercise History"),
        backgroundColor: Colors.blue[100], // Change to your desired color
      ),
      body: ListView.builder(
        itemCount: sessions.length,
        itemBuilder: (context, index) {
          return ExpansionTile(
            title: Text("Workedout for ${sessions[index]['duration']}"),
            children: List<Widget>.from(sessions[index]['exercises'].map(
              (exercise) => ListTile(
                title: Text(exercise['name'] ?? 'No Name'),
                subtitle: Text(
                    'Sets: ${exercise['sets']}, Reps: ${exercise['reps']}'),
              ),
            )),
          );
        },
      ),
    );
  }
}
