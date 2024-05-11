import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:healthsync_maybe/providers/timer_service.dart';

class QuickWorkoutPage extends StatelessWidget {
  const QuickWorkoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    TimerService timerService = Provider.of<TimerService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quick Workout'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              timerService.reset();  // Reset and stop the timer when finished
              Navigator.pop(context);
            },
            tooltip: 'Finish',
          ),
        ],
        leading: IconButton(
          icon: const Icon(Icons.arrow_downward),
          onPressed: () {
            Navigator.pop(context);  // Cancel workout
            }      
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AnimatedBuilder(
              animation: timerService,  // This will rebuild when the timer updates
              builder: (context, child) {
                return Text(
                  timerService.durationString,  // Display the formatted duration
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Add Exercise'),
            ),
            ElevatedButton(
              onPressed: () {
                timerService.reset();  // Optionally reset the timer on cancel as well
                Navigator.pop(context); // Cancel workout
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text('Cancel Workout'),
            ),
          ],
        ),
      ),
    );
  }
}
