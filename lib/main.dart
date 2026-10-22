import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:healthsync_maybe/firebase_options.dart';
import 'package:healthsync_maybe/providers/history_provider.dart';
import 'package:healthsync_maybe/providers/nutrition_data_provider.dart';
import 'package:healthsync_maybe/providers/quick_workout_provider.dart';
import 'package:healthsync_maybe/providers/timer_provider.dart';
import 'package:healthsync_maybe/providers/workout_template_provider.dart';
import 'screens/exercise_tab.dart';
import 'screens/history_tab.dart';
import 'screens/nutrition_tab.dart';
import 'screens/profile_tab.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final prefs = await SharedPreferences.getInstance();

  runApp(
    MultiProvider(
      providers: [
        Provider.value(value: prefs),
        ChangeNotifierProvider(create: (_) => TimerProvider()),
        ChangeNotifierProvider(create: (_) => ExerciseHistoryProvider(prefs)),
        ChangeNotifierProvider(create: (_) => WorkoutTemplateProvider(prefs)),
        ChangeNotifierProvider(create: (_) => QuickWorkoutProvider()),
        ChangeNotifierProvider(create: (_) => NutritionDataProvider(prefs)),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HealthSync',
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/profile': (context) => const MyHomePage(),
      },
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.blue[100],
        appBarTheme: AppBarTheme(backgroundColor: Colors.blue[100]),
      ),
    );
  }
}

class LoginScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  LoginScreen({super.key});

  Future<void> _submit(
      BuildContext context,
      Future<UserCredential> Function(
              {required String email, required String password})
          action) async {
    if (!_formKey.currentState!.validate()) return;
    try {
      await action(
          email: _emailController.text.trim(),
          password: _passwordController.text);
      if (context.mounted) Navigator.pushReplacementNamed(context, '/profile');
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.message ?? 'Authentication failed')));
      }
    }
  }

  String? _required(String? value, String field) =>
      (value == null || value.isEmpty) ? 'Please enter your $field' : null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (v) => _required(v, 'email'),
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (v) => _required(v, 'password'),
              ),
              ElevatedButton(
                child: const Text('Login'),
                onPressed: () =>
                    _submit(context, _auth.signInWithEmailAndPassword),
              ),
              ElevatedButton(
                child: const Text('Create account'),
                onPressed: () =>
                    _submit(context, _auth.createUserWithEmailAndPassword),
              ),
              ElevatedButton(
                child: const Text('Skip'),
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, '/profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'HealthSync',
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ),
      ),
      // IndexedStack keeps each tab's state alive when switching tabs.
      body: IndexedStack(
        index: _selectedIndex,
        children: const [
          ProfileTab(),
          NutritionTab(),
          ExerciseTab(),
          HistoryTab(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey[400],
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(
              icon: Icon(Icons.food_bank), label: 'Nutrition'),
          BottomNavigationBarItem(
              icon: Icon(Icons.fitness_center), label: 'Exercise'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
        ],
      ),
    );
  }
}
