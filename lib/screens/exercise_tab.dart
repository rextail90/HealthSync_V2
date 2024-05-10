import 'package:flutter/material.dart';

class ExerciseTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise'),
      ),
      body: const Center(
        child: Text(
          'This is the Exercise Tab',
          style: TextStyle(fontSize: 24.0),
        ),
      ),
    );
  }
}
