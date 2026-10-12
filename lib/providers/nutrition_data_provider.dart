import 'package:flutter/foundation.dart';
import 'package:healthsync_maybe/screens/nutrition_data.dart';

class NutritionDataProvider with ChangeNotifier {
  NutritionData _data = const NutritionData();

  NutritionData get data => _data;

  void update(int protein, int carbs, int fats) {
    _data = NutritionData(protein: protein, carbs: carbs, fats: fats);
    notifyListeners();
  }
}
