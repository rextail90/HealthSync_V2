import 'package:flutter/material.dart';

class ExerciseTemplatePage extends StatefulWidget {
  final List<Map<String, String>>? template;

  const ExerciseTemplatePage({Key? key, this.template}) : super(key: key);

  @override
  _ExerciseTemplatePageState createState() => _ExerciseTemplatePageState();
}

class _ExerciseTemplatePageState extends State<ExerciseTemplatePage> {
  late List<Map<String, String>> _exercises;

  @override
  void initState() {
    super.initState();
    _exercises = widget.template ?? [];
  }

  Future<void> _showAddExerciseDialog() async {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController setsController = TextEditingController();
    final TextEditingController repsController = TextEditingController();
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Exercise'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(hintText: 'Enter exercise name'),
              ),
              TextField(
                controller: setsController,
                decoration: const InputDecoration(hintText: 'Enter number of sets'),
              ),
              TextField(
                controller: repsController,
                decoration: const InputDecoration(hintText: 'Enter number of reps'),
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
                    'name': nameController.text,
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Template'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () => Navigator.pop(context, _exercises),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _exercises.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            child: ListTile(
              title: Text(_exercises[index]['name'] ?? 'No Name'),
              subtitle: Text('Sets: ${_exercises[index]['sets']}, Reps: ${_exercises[index]['reps']}'),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: _showAddExerciseDialog,
      ),
    );
  }
}
