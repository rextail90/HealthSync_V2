import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:healthsync_maybe/providers/timer_provider.dart';
import 'package:healthsync_maybe/screens/quick_workout_page.dart';
import 'package:healthsync_maybe/screens/exercise_template_page.dart';

class ExerciseTab extends StatefulWidget {
  const ExerciseTab({super.key});

  @override
  _ExerciseTabState createState() => _ExerciseTabState();
}

class _ExerciseTabState extends State<ExerciseTab> {
  List<List<Map<String, String>>> existingWorkoutTemplates = [];

  void navigateToTemplateCreation(BuildContext context) async {
    List<Map<String, String>>? newTemplate = await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const ExerciseTemplatePage()),
    );

    if (newTemplate != null) {
      setState(() {
        existingWorkoutTemplates.add(newTemplate);
      });
    }
  }

  void navigateToQuickWorkout(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const QuickWorkoutPage()),
    );
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
                return InkWell(
                  onTap: () async {
                    List<Map<String, String>>? updatedTemplate = await Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => ExerciseTemplatePage(template: existingWorkoutTemplates[index])),
                    );
                    if (updatedTemplate != null) {
                      setState(() {
                        existingWorkoutTemplates[index] = updatedTemplate;
                      });
                    }
                  },
                  child: ListTile(
                    title: Text(existingWorkoutTemplates[index].map((e) => e['name'] ?? 'No Name').join(', ')),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomSheet: timerProvider.isRunning ? GestureDetector(
        onTap: () => navigateToQuickWorkout(context),
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
