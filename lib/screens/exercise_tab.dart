import 'package:flutter/material.dart';
import 'package:healthsync_maybe/screens/exercise_template_page.dart';
import 'package:provider/provider.dart';
import 'package:healthsync_maybe/providers/timer_provider.dart';
import 'package:healthsync_maybe/screens/quick_workout_page.dart';

class ExerciseTab extends StatefulWidget {
  const ExerciseTab({super.key});

  @override
  _ExerciseTabState createState() => _ExerciseTabState();
}

class _ExerciseTabState extends State<ExerciseTab> {
  List<List<Map<String, String>>> existingWorkoutTemplates = [];

  void navigateToWorkout(BuildContext context) async {
    List<Map<String, String>> newTemplate = await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const ExerciseTemplatePage()),
    );

    if (newTemplate != null) {
      setState(() {
        existingWorkoutTemplates.add(newTemplate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final timerProvider = Provider.of<TimerProvider>(context);

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
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const QuickWorkoutPage(),
                  ));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.black, width: 1),
                ),
                child: const Text('Start Quick Workout'),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: existingWorkoutTemplates.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(existingWorkoutTemplates[index] as String),
                );
              },
            ),
            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Templates',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: ElevatedButton(
                onPressed: () async {
                  final List<String> exercises =
                      await Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const ExerciseTemplatePage(),
                  ));
                  if (exercises != null) {
                    // Save the template
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  side: const BorderSide(color: Colors.black, width: 1),
                ),
                child: const Text('Create New Template'),
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
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomSheet: timerProvider.isRunning
          ? GestureDetector(
              onTap: () => navigateToWorkout(context),
              child: Container(
                height: 50,
                color: Colors.blue,
                child: Center(
                  child: Text(timerProvider.durationString),
                ),
              ),
            )
          : null,
    );
  }
}
