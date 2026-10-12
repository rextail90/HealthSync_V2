import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:healthsync_maybe/providers/nutrition_data_provider.dart';
import 'package:healthsync_maybe/widgets/macro_pie_chart.dart';

const _days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  final Map<String, int> _hoursByDay = {};

  void _showInputDialog() {
    final hoursController = TextEditingController();
    final dayController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Workout Data'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              controller: hoursController,
              decoration:
                  const InputDecoration(hintText: 'Enter hours (0-24 only)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: dayController,
              decoration: const InputDecoration(
                  hintText: 'Enter day (3 letters only): Mon, Tue, ...'),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text('Add'),
            onPressed: () {
              final input = dayController.text.trim().toLowerCase();
              final day =
                  _days.where((d) => d.toLowerCase() == input).firstOrNull;
              final hours = int.tryParse(hoursController.text.trim());
              if (day == null || hours == null || hours < 0 || hours > 24) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Enter 0-24 hours and a day like Mon')));
                return;
              }
              setState(() => _hoursByDay[day] = hours);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final nutrition = context.watch<NutritionDataProvider>().data;
    final total = nutrition.protein + nutrition.carbs + nutrition.fats;
    String pct(int v) => (v / total * 100).toStringAsFixed(1);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'User Profile',
          style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const CircleAvatar(
            radius: 60.0,
            backgroundColor: Colors.blue,
            child: Icon(Icons.person, size: 60.0, color: Colors.white),
          ),
          const SizedBox(height: 10.0),
          const Text(
            'User',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 40.0),
          _card(
            title: 'Macros Eaten Today',
            children: [
              Text(
                'Protein: ${nutrition.protein}g | Carbs: ${nutrition.carbs}g | Fat: ${nutrition.fats}g',
                style: const TextStyle(fontSize: 16.0, color: Colors.black),
              ),
              const SizedBox(height: 20.0),
              MacroPieChart(slices: [
                (
                  value: nutrition.protein.toDouble(),
                  color: Colors.blue,
                  label: 'Protein\n${pct(nutrition.protein)}%'
                ),
                (
                  value: nutrition.carbs.toDouble(),
                  color: Colors.green,
                  label: 'Carbs\n${pct(nutrition.carbs)}%'
                ),
                (
                  value: nutrition.fats.toDouble(),
                  color: Colors.orange,
                  label: 'Fats\n${pct(nutrition.fats)}%'
                ),
              ]),
            ],
          ),
          const SizedBox(height: 20.0),
          _card(
            title: 'Weekly Workout Hours',
            children: [
              const SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [for (final day in _days) _dayBar(day)],
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _showInputDialog,
                child: const Text('Add Workout Data'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _card({required String title, required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
          ...children,
        ],
      ),
    );
  }

  Widget _dayBar(String day) {
    final hours = _hoursByDay[day] ?? 0;
    return Column(
      children: [
        if (hours > 0) Text('$hours'),
        Container(
          width: 30,
          height: hours * 20.0,
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        Text(day),
      ],
    );
  }
}
