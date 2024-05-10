import 'package:flutter/material.dart';
import 'screens/profile_tab.dart';
import 'screens/nutrition_tab.dart';
import 'screens/exercise_tab.dart';
import 'screens/history_tab.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HealthSync',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  // Colors for BottomNavigationBar
  Color _backgroundColor = Colors.white;
  Color _selectedItemColor = Colors.blue;
  Color? _unselectedItemColor = Colors.grey[400];

  static final List<Widget> _tabPages = [
    ProfileTab(),
    NutritionTab(),
    ExerciseTab(),
    HistoryTab(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
          'HealthSync',
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ),
        
      ),
      body: _tabPages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        backgroundColor: _backgroundColor, // Set background color
        selectedItemColor: _selectedItemColor, // Set color of selected item
        unselectedItemColor: _unselectedItemColor, // Set color of unselected items
        onTap: _onTabTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.food_bank),
            label: 'Nutrition',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Exercise',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
        ],
      ),
    );
  }
}
