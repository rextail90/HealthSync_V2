import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:healthsync_maybe/providers/nutrition_data_provider.dart';
import 'package:healthsync_maybe/widgets/macro_pie_chart.dart';

class NutritionTab extends StatelessWidget {
  const NutritionTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nutrition')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          Text(
            'Enter Nutrition Data:',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20.0),
          ),
          SizedBox(height: 20.0),
          NutritionForm(),
        ],
      ),
    );
  }
}

class NutritionForm extends StatefulWidget {
  const NutritionForm({super.key});

  @override
  State<NutritionForm> createState() => _NutritionFormState();
}

class _NutritionFormState extends State<NutritionForm> {
  final carbsController = TextEditingController();
  final proteinController = TextEditingController();
  final fatController = TextEditingController();
  final carbGoalController = TextEditingController();
  final proteinGoalController = TextEditingController();
  final fatGoalController = TextEditingController();

  List<TextEditingController> get _all => [
        carbsController,
        proteinController,
        fatController,
        carbGoalController,
        proteinGoalController,
        fatGoalController,
      ];

  @override
  void dispose() {
    for (final c in _all) {
      c.dispose();
    }
    super.dispose();
  }

  Widget _field(TextEditingController controller, String label) =>
      TextFormField(
        controller: controller,
        decoration: InputDecoration(labelText: label),
        keyboardType: TextInputType.number,
      );

  void _showMessage(String title, Widget content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: content,
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _submit() {
    final values = _all.map((c) => int.tryParse(c.text.trim())).toList();
    // Goals divide the intake, so they must be positive; intake may be 0.
    if (values.any((v) => v == null || v < 0) ||
        values.skip(3).any((v) => v == 0)) {
      _showMessage('Error',
          const Text('Please enter whole numbers for all fields (goals > 0).'));
      return;
    }
    final [carbs, protein, fat, carbGoal, proteinGoal, fatGoal] =
        values.cast<int>();

    context.read<NutritionDataProvider>().update(protein, carbs, fat);

    String pct(int value, int goal) =>
        (value / goal * 100).toStringAsFixed(1);
    _showMessage(
      'How far you are from Goals:',
      SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Carbs: ${carbs}g'),
            Text('Protein: ${protein}g'),
            Text('Fats: ${fat}g'),
            const SizedBox(height: 20),
            MacroPieChart(slices: [
              (
                value: carbs.toDouble(),
                color: Colors.green,
                label: 'Carbs\n${pct(carbs, carbGoal)}%'
              ),
              (
                value: protein.toDouble(),
                color: Colors.blue,
                label: 'Protein\n${pct(protein, proteinGoal)}%'
              ),
              (
                value: fat.toDouble(),
                color: Colors.orange,
                label: 'Fat\n${pct(fat, fatGoal)}%'
              ),
            ]),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _field(carbsController, 'Carbohydrates'),
        _field(proteinController, 'Protein'),
        _field(fatController, 'Fat'),
        const SizedBox(height: 20.0),
        const Text('Enter Your Goals:'),
        _field(carbGoalController, 'Carbohydrates Goal'),
        _field(proteinGoalController, 'Protein Goal'),
        _field(fatGoalController, 'Fat Goal'),
        const SizedBox(height: 20.0),
        ElevatedButton(
          onPressed: _submit,
          child: const Text('Update and View Nutrition'),
        ),
      ],
    );
  }
}
