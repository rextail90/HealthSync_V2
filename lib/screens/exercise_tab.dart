import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:healthsync_maybe/providers/timer_provider.dart';
import 'package:healthsync_maybe/providers/workout_template_provider.dart';
import 'package:healthsync_maybe/screens/exercise_template_page.dart';
import 'package:healthsync_maybe/screens/quick_workout_page.dart';
import 'package:healthsync_maybe/screens/template_workout_page.dart';
import 'package:healthsync_maybe/widgets/timer_text.dart';

class ExerciseTab extends StatefulWidget {
  const ExerciseTab({super.key});

  @override
  State<ExerciseTab> createState() => _ExerciseTabState();
}

class _ExerciseTabState extends State<ExerciseTab> {
  // The workout page the timer bar returns to; null means quick workout.
  List<Map<String, String>>? _activeTemplate;

  Future<void> _createTemplate() async {
    final newTemplate =
        await Navigator.of(context).push<List<Map<String, String>>>(
      MaterialPageRoute(builder: (_) => const ExerciseTemplatePage()),
    );
    if (newTemplate != null && mounted) {
      context.read<WorkoutTemplateProvider>().addTemplate(newTemplate);
    }
  }

  void _startWorkout(List<Map<String, String>>? template) {
    _activeTemplate = template;
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => template == null
          ? const QuickWorkoutPage()
          : TemplateWorkoutPage(template: template),
    ));
  }

  Future<void> _confirmStart(List<Map<String, String>> template) async {
    final start = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Start Workout'),
        content: const Text('Do you want to start the workout?'),
        actions: <Widget>[
          TextButton(
            child: const Text('No'),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          TextButton(
            child: const Text('Yes'),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );
    if (start == true && mounted) _startWorkout(template);
  }

  Widget _bigButton(String label, VoidCallback onPressed) => ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
          foregroundColor: Colors.white,
          side: const BorderSide(color: Colors.black, width: 1),
        ),
        child: Text(label),
      );

  @override
  Widget build(BuildContext context) {
    final isRunning = context.select<TimerProvider, bool>((t) => t.isRunning);
    final templateProvider = context.watch<WorkoutTemplateProvider>();
    final templates = templateProvider.existingWorkoutTemplates;

    return Scaffold(
      appBar: AppBar(title: const Text('Workouts')),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: <Widget>[
          const SizedBox(height: 20),
          Center(child: _bigButton('Create New Template', _createTemplate)),
          const SizedBox(height: 20),
          Center(
              child:
                  _bigButton('Start Quick Workout', () => _startWorkout(null))),
          const SizedBox(height: 20),
          const Text(
            'Existing Workout Templates',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          for (final (index, exercises) in templates.indexed)
            InkWell(
              onTap: () => _confirmStart(exercises),
              child: Container(
                margin: const EdgeInsets.only(top: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  title: Column(
                    children: [
                      for (final e in exercises)
                        Text(
                            'Name: ${e['name']}, Sets: ${e['sets']}, Reps: ${e['reps']}'),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      templateProvider.deleteTemplate(index);
                      // Only end the running workout if it uses this template.
                      if (identical(exercises, _activeTemplate)) {
                        _activeTemplate = null;
                        context.read<TimerProvider>().reset();
                      }
                    },
                  ),
                ),
              ),
            ),
          const SizedBox(height: 70), // room for the timer bar
        ],
      ),
      bottomSheet: isRunning
          ? GestureDetector(
              onTap: () => _startWorkout(_activeTemplate),
              child: Container(
                height: 50,
                color: Colors.blue,
                child: const Center(child: TimerText()),
              ),
            )
          : null,
    );
  }
}
