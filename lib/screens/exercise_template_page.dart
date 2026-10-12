import 'package:flutter/material.dart';
import 'package:healthsync_maybe/widgets/add_exercise_dialog.dart';

class ExerciseTemplatePage extends StatefulWidget {
  const ExerciseTemplatePage({super.key});

  @override
  State<ExerciseTemplatePage> createState() => _ExerciseTemplatePageState();
}

class _ExerciseTemplatePageState extends State<ExerciseTemplatePage> {
  final List<Map<String, String>> _exercises = [];

  Future<void> _addExercise() async {
    final exercise = await showAddExerciseDialog(context);
    if (exercise != null) setState(() => _exercises.add(exercise));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Template'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              if (_exercises.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Add a workout first!')),
                );
              } else {
                Navigator.pop(context, _exercises);
              }
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _exercises.length,
        itemBuilder: (context, index) {
          final exercise = _exercises[index];
          return Card(
            child: ListTile(
              title: Text(exercise['name'] ?? 'No Name'),
              subtitle:
                  Text('Sets: ${exercise['sets']}, Reps: ${exercise['reps']}'),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => setState(() => _exercises.removeAt(index)),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addExercise,
        child: const Icon(Icons.add),
      ),
    );
  }
}
