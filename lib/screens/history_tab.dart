import 'package:flutter/material.dart';

class HistoryTab extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
      ),
      body: const Center(
        child: Text(
          'This is the History Tab',
          style: TextStyle(fontSize: 24.0),
        ),
      ),
    );
  }
}
