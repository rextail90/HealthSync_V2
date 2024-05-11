import 'package:flutter/material.dart';
import 'screens/profile_tab.dart';
import 'screens/nutrition_tab.dart';
import 'screens/exercise_tab.dart';
import 'screens/history_tab.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HealthSync',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  // Colors for BottomNavigationBar
  final Color _backgroundColor = Colors.white;
  final Color _selectedItemColor = Colors.blue;
  final Color? _unselectedItemColor = Colors.grey[400];

  static final List<Widget> _tabPages = [
    const ProfileTab(),
    const NutritionTab(),
    const ExerciseTab(),
    const HistoryTab(),
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
