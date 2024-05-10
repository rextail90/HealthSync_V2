import 'package:flutter/material.dart';

class ProfileTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'User Profile',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Column containing CircleAvatar and 'User' text
              const Column(
                children: [
                  CircleAvatar(
                    radius: 70.0,
                    backgroundColor: Colors.blue,
                    child: Icon(
                      Icons.person,
                      size: 60.0,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10.0), // Spacer between CircleAvatar and 'User' text
                  Text(
                    'User',
                    style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 40.0), // Spacer between 'User' and widgets below

              // Macros eaten widget with border
              _buildBorderedWidget(
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Macros Eaten Today',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Protein: 50g | Carbs: 120g | Fat: 30g',
                      style: TextStyle(fontSize: 16.0, color: Colors.black),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20.0), // Spacer between widgets

              // Weekly Workout Hours widget with border
              _buildBorderedWidget(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Weekly Workout Hours',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildDayWorkoutBar('Mon', 2.5), // Example data for Monday
                        _buildDayWorkoutBar('Tue', 3.0), // Example data for Tuesday
                        _buildDayWorkoutBar('Wed', 2.0), // Example data for Wednesday
                        _buildDayWorkoutBar('Thu', 2.5), // Example data for Thursday
                        _buildDayWorkoutBar('Fri', 3.5), // Example data for Friday
                        _buildDayWorkoutBar('Sat', 4.0), // Example data for Saturday
                        _buildDayWorkoutBar('Sun', 3.0), // Example data for Sunday
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build a bordered widget
  Widget _buildBorderedWidget({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: child,
    );
  }

  // Helper method to build workout hour bar for a specific day
  Widget _buildDayWorkoutBar(String day, double hours) {
    return Column(
      children: [
        Text(
          day,
          style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 4.0),
          height: hours * 20.0, // Adjust height based on workout hours
          width: 30.0,
          color: Colors.blue,
          alignment: Alignment.center,
          child: Text(
            hours.toStringAsFixed(1), // Display hours with one decimal place
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}