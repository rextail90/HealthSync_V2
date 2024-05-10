import 'package:flutter/material.dart';

class HomeTab extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.home,
              size: 100.0,
              color: Colors.blue,
            ),
            SizedBox(height: 20.0),
            Text(
              'Welcome to Home Tab',
              style: TextStyle(fontSize: 24.0),
            ),
          ],
        ),
      ),
    );
  }
}
