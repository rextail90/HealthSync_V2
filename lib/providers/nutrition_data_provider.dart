import 'package:flutter/material.dart';
import 'package:healthsync_maybe/screens/nutrition_data.dart'; // Assuming this file has the NutritionData class

class NutritionDataProvider extends StatefulWidget {
  final Widget child;
  final NutritionData initialData;

  const NutritionDataProvider(
      {super.key, required this.child, required this.initialData});

  static NutritionData of(BuildContext context) {
    _NutritionDataProviderState providerState =
        context.findAncestorStateOfType<_NutritionDataProviderState>()!;
    return providerState.data; // Correctly return the data.
  }

  @override
  _NutritionDataProviderState createState() => _NutritionDataProviderState();
}

class _NutritionDataProviderState extends State<NutritionDataProvider> {
  late NutritionData data; // State that holds the nutrition data

  @override
  void initState() {
    super.initState();
    data = widget.initialData;
  }

  void updateNutritionData(int protein, int carbs, int fats) {
    setState(() {
      data = NutritionData(protein: protein, carbs: carbs, fats: fats);
    });
  }

  @override
  Widget build(BuildContext context) {
    return NutritionDataInherited(
      data: data,
      child: widget.child,
    );
  }
}

class NutritionDataInherited extends InheritedWidget {
  final NutritionData data;

  const NutritionDataInherited({super.key, required this.data, required super.child});

  @override
  bool updateShouldNotify(NutritionDataInherited oldWidget) {
    return data != oldWidget.data;
  }
}
