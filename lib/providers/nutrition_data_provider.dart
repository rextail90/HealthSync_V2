// nutrition_data_provider.dart
import 'package:flutter/material.dart';
import 'package:healthsync_maybe/screens/nutrition_data.dart';

class NutritionDataProvider extends StatefulWidget {
  final Widget child;
  final NutritionData data; // This is required for initialization

  NutritionDataProvider({Key? key, required this.child, required this.data})
      : super(key: key);

  static NutritionData of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_NutritionDataInherited>()!
        .data;
  }

  @override
  _NutritionDataProviderState createState() => _NutritionDataProviderState();
}

class _NutritionDataProviderState extends State<NutritionDataProvider> {
  late NutritionData _data;

  @override
  void initState() {
    super.initState();
    _data = widget.data; // Initialize data from widget
  }

  void updateNutritionData(int protein, int carbs, int fats) {
    setState(() {
      _data = NutritionData(protein: protein, carbs: carbs, fats: fats);
    });
  }

  @override
  Widget build(BuildContext context) {
    return _NutritionDataInherited(
      data: _data,
      child: widget.child,
    );
  }
}

class _NutritionDataInherited extends InheritedWidget {
  final NutritionData data;

  _NutritionDataInherited({
    Key? key,
    required this.data,
    required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_NutritionDataInherited old) => data != old.data;
}
