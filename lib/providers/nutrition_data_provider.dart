import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:healthsync_maybe/providers/storage.dart';
import 'package:healthsync_maybe/screens/nutrition_data.dart';

class NutritionDataProvider with ChangeNotifier {
  static const _key = 'nutrition_today';
  final SharedPreferences _prefs;
  NutritionData _data;

  // Macros are per day: data saved on an earlier day loads as zeros.
  NutritionDataProvider(this._prefs)
      : _data = readJson(
            _prefs,
            _key,
            const NutritionData(),
            (json) => json['date'] == _today()
                ? NutritionData(
                    protein: json['protein'] as int,
                    carbs: json['carbs'] as int,
                    fats: json['fats'] as int)
                : const NutritionData());

  NutritionData get data => _data;

  void update(int protein, int carbs, int fats) {
    _data = NutritionData(protein: protein, carbs: carbs, fats: fats);
    writeJson(_prefs, _key, {
      'date': _today(),
      'protein': protein,
      'carbs': carbs,
      'fats': fats,
    });
    notifyListeners();
  }

  static String _today() => DateTime.now().toIso8601String().substring(0, 10);
}
