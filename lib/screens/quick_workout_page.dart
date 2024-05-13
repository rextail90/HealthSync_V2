import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:healthsync_maybe/providers/timer_provider.dart';
import 'package:healthsync_maybe/screens/completed_exercise_page.dart';
import 'package:healthsync_maybe/providers/quick_workout_provider.dart';

class QuickWorkoutPage extends StatefulWidget {
  const QuickWorkoutPage({super.key});

  @override
  _QuickWorkoutPageState createState() => _QuickWorkoutPageState();
}

class _QuickWorkoutPageState extends State<QuickWorkoutPage> {
  final List<Map<String, String>> _completedExercises = [];

  @override
  void initState() {
    super.initState();
    Provider.of<TimerProvider>(context, listen: false).start();
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
              TextField(controller: nameController, decoration: const InputDecoration(hintText: 'Enter exercise name')),
              TextField(controller: setsController, decoration: const InputDecoration(hintText: 'Enter number of sets')),
              TextField(controller: repsController, decoration: const InputDecoration(hintText: 'Enter number of reps')),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                if (nameController.text.isNotEmpty) {
                  Provider.of<QuickWorkoutProvider>(context, listen: false).addExercise({
                    'name': nameController.text,
                    'sets': setsController.text,
                    'reps': repsController.text,
                  });
                  Navigator.of(context).pop();
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
    final timerProvider = Provider.of<TimerProvider>(context);
    final quickWorkoutProvider = Provider.of<QuickWorkoutProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quick Workout'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              timerProvider.stop();  // Stop the timer
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CompletedExercisesPage(
                    duration: timerProvider.durationString,
                    completedExercises: _completedExercises,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Text(timerProvider.durationString, style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              timerProvider.stop();
              Navigator.pop(context);
              timerProvider.reset();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 255, 255, 255),
               textStyle: const TextStyle(color: Colors.white),
            ),
            child: const Text('Cancel Workout'),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: quickWorkoutProvider.exercises.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.all(8),
                  elevation: 2,
                  child: ListTile(
                    title: Text(quickWorkoutProvider.exercises[index]['name'] ?? 'No Name'),
                    subtitle: Text('Sets: ${quickWorkoutProvider.exercises[index]['sets']}, Reps: ${quickWorkoutProvider.exercises[index]['reps']}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.check, color: Colors.green),
                          onPressed: () {
                            setState(() {
                              _completedExercises.add(quickWorkoutProvider.exercises[index]);
                              quickWorkoutProvider.removeExercise(index);
                            });
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            quickWorkoutProvider.removeExercise(index);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddExerciseDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
