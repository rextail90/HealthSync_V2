import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:healthsync_maybe/providers/timer_provider.dart';
import 'package:healthsync_maybe/screens/quick_workout_page.dart';

class ExerciseTab extends StatefulWidget {
  const ExerciseTab({Key? key}) : super(key: key);

  @override
  _ExerciseTabState createState() => _ExerciseTabState();
}

class _ExerciseTabState extends State<ExerciseTab> {
  void navigateToWorkout(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const QuickWorkoutPage(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final timerProvider = Provider.of<TimerProvider>(context);

    return Scaffold(
      appBar: AppBar(
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
                'Templates',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
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
      bottomSheet: timerProvider.isRunning ? GestureDetector(
        onTap: () => navigateToWorkout(context),
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
