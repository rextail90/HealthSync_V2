import 'package:flutter/material.dart';

/// Returns {'name', 'sets', 'reps'}, or null if cancelled.
Future<Map<String, String>?> showAddExerciseDialog(BuildContext context) {
  final name = TextEditingController();
  final sets = TextEditingController();
  final reps = TextEditingController();

  return showDialog<Map<String, String>>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Add Exercise'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
              controller: name,
              decoration:
                  const InputDecoration(hintText: 'Enter exercise name')),
          TextField(
              controller: sets,
              keyboardType: TextInputType.number,
              decoration:
                  const InputDecoration(hintText: 'Enter number of sets')),
          TextField(
              controller: reps,
              keyboardType: TextInputType.number,
              decoration:
                  const InputDecoration(hintText: 'Enter number of reps')),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (name.text.trim().isEmpty) return;
            Navigator.pop(context, {
              'name': name.text.trim(),
              'sets': sets.text,
              'reps': reps.text,
            });
          },
          child: const Text('Add'),
        ),
      ],
    ),
  );
}
