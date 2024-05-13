import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:healthsync_maybe/providers/timer_provider.dart';
import 'package:healthsync_maybe/screens/quick_workout_page.dart';
import 'package:healthsync_maybe/screens/exercise_template_page.dart';
import 'package:healthsync_maybe/screens/template_workout_page.dart';
import 'package:healthsync_maybe/providers/workout_template_provider.dart'; // Assuming you have this provider

class ExerciseTab extends StatefulWidget {
  const ExerciseTab({super.key});

  @override
  _ExerciseTabState createState() => _ExerciseTabState();
}

class _ExerciseTabState extends State<ExerciseTab> {
  String? lastNavigatedPage;
  List<Map<String, String>>? lastTemplate;

  void navigateToTemplateCreation(BuildContext context) async {
    List<Map<String, String>>? newTemplate = await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const ExerciseTemplatePage()),
    );

    if (newTemplate != null) {
      Provider.of<WorkoutTemplateProvider>(context, listen: false).addTemplate(newTemplate);
      lastNavigatedPage = 'TemplateWorkoutPage';
      lastTemplate = newTemplate; // Store the last navigated template
    }
  }

  void navigateToQuickWorkout(BuildContext context) {
    lastNavigatedPage = 'QuickWorkoutPage';
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const QuickWorkoutPage()),
    );
  }

  void navigateToTemplateWorkout(BuildContext context, List<Map<String, String>> template) {
    lastNavigatedPage = 'TemplateWorkoutPage';
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => TemplateWorkoutPage(template: template)),
    );
  }

  void navigateToLastPage(BuildContext context) {
    if (lastNavigatedPage == 'QuickWorkoutPage') {
      navigateToQuickWorkout(context);
    } else if (lastNavigatedPage == 'TemplateWorkoutPage' && lastTemplate != null) {
      navigateToTemplateWorkout(context, lastTemplate!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final timerProvider = Provider.of<TimerProvider>(context);
    List<List<Map<String, String>>> existingWorkoutTemplates = Provider.of<WorkoutTemplateProvider>(context).existingWorkoutTemplates;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[100],
        title: const Text('Workouts'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.topCenter,
              child: ElevatedButton(
                onPressed: () => navigateToTemplateCreation(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.black, width: 1),
                ),
                child: const Text('Create New Template'),
              ),
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.topCenter,
              child: ElevatedButton(
                onPressed: () => navigateToQuickWorkout(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.black, width: 1),
                ),
                child: const Text('Start Quick Workout'),
              ),
            ),
            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Existing Workout Templates',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: existingWorkoutTemplates.length,
              itemBuilder: (context, index) {
                final exercises = existingWorkoutTemplates[index];
                return InkWell(
                  onTap: () async {
                    bool? startWorkout = await showDialog<bool>(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Start Workout'),
                          content: const Text('Do you want to start the workout?'),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('No'),
                              onPressed: () {
                                Navigator.of(context).pop(false);
                              },
                            ),
                            TextButton(
                              child: const Text('Yes'),
                              onPressed: () {
                                Navigator.of(context).pop(true);
                              },
                            ),
                          ],
                        );
                      },
                    );

                    if (startWorkout == true) {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => TemplateWorkoutPage(template: exercises)),
                      );
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      title: Column(
                        children: exercises.map<Widget>((exercise) {
                          return Text('Name: ${exercise['name']}, Sets: ${exercise['sets']}, Reps: ${exercise['reps']}');
                        }).toList(),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              Provider.of<WorkoutTemplateProvider>(context, listen: false).deleteTemplate(index);
                              timerProvider.reset();
                              timerProvider.stop();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomSheet: timerProvider.isRunning ? GestureDetector(
        onTap: () => navigateToLastPage(context),
        child: Container(
          height: 50,
          color: Colors.blue,
          child: Center(
            child: Text(timerProvider.durationString),
          ),
        ),
      ) : null,
    );
  }
}
