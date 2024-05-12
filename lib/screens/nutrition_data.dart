// File: nutrition_data.dart
class NutritionData {
  int protein;
  int carbs;
  int fats;

  NutritionData({this.protein = 0, this.carbs = 0, this.fats = 0});

  // This method updates the properties of the class
  void updateNutritionData(int newProtein, int newCarbs, int newFats) {
    protein = newProtein;
    carbs = newCarbs;
    fats = newFats;
  }
}
