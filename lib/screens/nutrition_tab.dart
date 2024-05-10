import 'package:flutter/material.dart';

class NutritionTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nutrition'),
      ),
      body: const Center(
        child: Text(
          'This is the Nutrition Tab',
          style: TextStyle(fontSize: 24.0),
        ),
      ),
    );
  }
}
