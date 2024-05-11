import 'package:healthsync_maybe/providers/timer_provider.dart';
import 'dart:async';
import 'package:healthsync_maybe/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/profile_tab.dart';
import 'screens/nutrition_tab.dart';
import 'screens/exercise_tab.dart';
import 'screens/history_tab.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    ChangeNotifierProvider<TimerProvider>(
      create: (context) => TimerProvider(),
      child: const MyApp(), // Your main application widget
    ),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      title: 'My App',
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/profile': (context) => const MyHomePage(),
      },
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.blue[100], // Set the global background color here
      )
    );
  }
}

class LoginScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  LoginScreen({super.key});

  Future<UserCredential> signInWithEmailPassword(String email, String password) async {
  return await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<UserCredential> createAccount(String email, String password) async {
  return await _auth.createUserWithEmailAndPassword(email: email, password: password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      appBar: AppBar(
        backgroundColor: Colors.blue[100],
        title: const Text('Login'),
      ),
      body: Container(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                ElevatedButton(
                  child: const Text('Login'),
                    onPressed: () async {
                      final String email = _emailController.text;
                      final String password = _passwordController.text;
                        final UserCredential user = await signInWithEmailPassword(email, password);

                        // If the user is signed in, navigate to the profile page
                        if (user != null) {
                          Navigator.pushReplacementNamed(context, '/profile');
                        }
                    }
                ),
                ElevatedButton(
                  child: Text('Create account'),
                  onPressed: () async {
                    final String email = _emailController.text;
                    final String password = _passwordController.text;

                    try {
                      final UserCredential user = await createAccount(email, password);

                      // If the user is created, navigate to the profile page
                      if (user != null) {
                        Navigator.pushReplacementNamed(context, '/profile');
                      }
                    } catch (e) {
                      // Handle the error
                      print(e);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
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
        backgroundColor: Colors.blue[100],
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