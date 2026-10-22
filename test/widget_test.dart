import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:healthsync_maybe/providers/nutrition_data_provider.dart';
import 'package:healthsync_maybe/screens/nutrition_tab.dart';
import 'package:healthsync_maybe/widgets/macro_pie_chart.dart';

void main() {
  testWidgets('MacroPieChart paints nothing when all macros are 0',
      (tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: MacroPieChart(slices: [
        (value: 0, color: Colors.blue, label: 'Protein'),
        (value: 0, color: Colors.green, label: 'Carbs'),
      ]),
    ));
    expect(tester.takeException(), isNull);
  });

  Future<NutritionDataProvider> pumpNutritionTab(WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final provider =
        NutritionDataProvider(await SharedPreferences.getInstance());
    await tester.pumpWidget(ChangeNotifierProvider.value(
      value: provider,
      child: const MaterialApp(home: NutritionTab()),
    ));
    return provider;
  }

  Future<void> submit(WidgetTester tester, List<String> values) async {
    for (var i = 0; i < values.length; i++) {
      await tester.enterText(find.byType(TextFormField).at(i), values[i]);
    }
    final button = find.text('Update and View Nutrition');
    await tester.ensureVisible(button);
    await tester.tap(button);
    await tester.pumpAndSettle();
  }

  testWidgets('NutritionForm rejects bad input', (tester) async {
    final provider = await pumpNutritionTab(tester);

    await submit(tester, ['100', 'abc', '20', '200', '150', '0']);

    expect(find.text('Error'), findsOneWidget);
    expect(provider.data.protein, 0);
  });

  testWidgets('NutritionForm updates shared nutrition data', (tester) async {
    final provider = await pumpNutritionTab(tester);

    await submit(tester, ['250', '120', '60', '300', '150', '70']);

    expect(find.text('How far you are from Goals:'), findsOneWidget);
    expect(provider.data.carbs, 250);
    expect(provider.data.protein, 120);
    expect(provider.data.fats, 60);
  });
}
