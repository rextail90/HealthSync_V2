import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:healthsync_maybe/providers/timer_provider.dart';

class QuickWorkoutPage extends StatefulWidget {
  const QuickWorkoutPage({super.key});

  @override
  _QuickWorkoutPageState createState() => _QuickWorkoutPageState();
}

class _QuickWorkoutPageState extends State<QuickWorkoutPage> {
  @override
  void initState() {
    super.initState();
    Provider.of<TimerProvider>(context, listen: false).start();
  }

  @override
  Widget build(BuildContext context) {
    final timerProvider = Provider.of<TimerProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quick Workout'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              timerProvider.reset();
              Navigator.pop(context);
            },
            tooltip: 'Finish',
          ),
        ],
        leading: IconButton(
          icon: const Icon(Icons.arrow_downward),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              timerProvider.durationString,
              style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Add Exercise'),
            ),
            ElevatedButton(
              onPressed: () {
                timerProvider.reset();
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Cancel Workout'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    // Consider whether to stop the timer here if needed
  }
}
