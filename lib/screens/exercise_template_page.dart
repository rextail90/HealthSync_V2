import 'package:flutter/material.dart';
import 'package:healthsync_maybe/screens/exercise_tab.dart';

class ExerciseTemplatePage extends StatefulWidget {
  const ExerciseTemplatePage({Key? key}) : super(key: key);

  @override
  _ExerciseTemplatePageState createState() => _ExerciseTemplatePageState();
}

class _ExerciseTemplatePageState extends State<ExerciseTemplatePage> {
  final List<Map<String, String>> _exercises = [];

  Future<void> _showAddExerciseDialog() async {
    final TextEditingController controller = TextEditingController();
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Exercise'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: 'Enter exercise name'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                setState(() {
                  _exercises.add(controller.text as Map<String, String>);
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Template'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context, _exercises);
              }
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _exercises.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            child: ListTile(
              title: Text(_exercises[index]['name']!),
              subtitle: Text(
                  'Sets: ${_exercises[index]['sets']}, Reps: ${_exercises[index]['reps']}'),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              TextEditingController controller = TextEditingController();
              TextEditingController setsController = TextEditingController();
              TextEditingController repsController = TextEditingController();
              return AlertDialog(
                title: const Text('Add Exercise'),
                content: Column(
                  children: <Widget>[
                    TextField(
                      controller: controller,
                      decoration: const InputDecoration(
                          hintText: 'Enter exercise name'),
                    ),
                    TextField(
                      controller: setsController,
                      decoration: const InputDecoration(
                          hintText: 'Enter number of sets'),
                    ),
                    TextField(
                      controller: repsController,
                      decoration: const InputDecoration(
                          hintText: 'Enter number of reps'),
                    ),
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: const Text('Add'),
                    onPressed: () {
                      setState(() {
                        _exercises.add({
                          'name': controller.text,
                          'sets': setsController.text,
                          'reps': repsController.text,
                        });
                      });
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}