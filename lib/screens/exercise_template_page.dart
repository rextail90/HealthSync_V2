import 'package:flutter/material.dart';

class ExerciseTemplatePage extends StatefulWidget {
  const ExerciseTemplatePage({super.key});

  @override
  _ExerciseTemplatePageState createState() => _ExerciseTemplatePageState();
}

class _ExerciseTemplatePageState extends State<ExerciseTemplatePage> {
  final List<String> _exercises = [];

  Future<void> _showAddExerciseDialog() async {
    final TextEditingController controller = TextEditingController();
    await showDialog(
      context: context,
      builder: (BuildContext dialogContext) { // Use a different context variable here
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
                Navigator.of(dialogContext).pop(); // Use dialogContext here
              },
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  setState(() {
                    _exercises.add(controller.text);
                  });
                  Navigator.of(dialogContext).pop(); // Use dialogContext here
                }
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
              Navigator.pop(context);
            }
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              // Save the template and go back to the previous page
              Navigator.pop(context, _exercises);
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _exercises.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(_exercises[index]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddExerciseDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
