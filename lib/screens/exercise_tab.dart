import 'package:flutter/material.dart';
import 'dart:async';

import 'package:healthsync_maybe/providers/timer_service.dart';
import 'package:healthsync_maybe/screens/quick_workout_page.dart';
import 'package:provider/provider.dart';

class ExerciseTab extends StatelessWidget {
  const ExerciseTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final timerService = Provider.of<TimerService>(context);  // Get the TimerService

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
            // Add more widgets as needed
          ],
        ),
      ),
    );
  }
}

  Widget _buildWorkoutTemplate(String title, List<String> exercises) {
    return Card(
      child: ExpansionTile(
        title: Text(title),
        children: exercises.map((exercise) => ListTile(title: Text(exercise))).toList(),
      ),
    );
  }
