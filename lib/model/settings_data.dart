import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsData extends ChangeNotifier {
  List<String> checklist = [];
  ThemeMode theme = ThemeMode.system;
  bool showAnimalImages = true;
  List<String> hiddenAnimals = [];

  SettingsData() {
    loadSettings();
  }

  Future loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    checklist = prefs.getStringList('checklist') ?? [];
    theme = ThemeMode.values
            .firstWhereOrNull((e) => e.name == prefs.getString('theme')) ??
        ThemeMode.system;
    showAnimalImages = prefs.getBool('show_animal_images') ?? true;
    hiddenAnimals = prefs.getStringList('hidden_animals') ?? [];
    notifyListeners();
  }

  Future storeSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await Future.wait([
      prefs.setStringList('checklist', checklist),
      prefs.setString('theme', theme.name),
      prefs.setBool('show_animal_images', showAnimalImages),
      prefs.setStringList('hidden_animals', hiddenAnimals),
    ]);
  }

  bool isChecked(String name) {
    return checklist.contains(name);
  }

  void toggleCheck(String name) {
    if (checklist.contains(name)) {
      checklist.removeWhere((e) => e == name);
    } else {
      checklist.add(name);
    }
    storeSettings();
    notifyListeners();
  }

  void resetChecklist() {
    checklist.clear();
    storeSettings();
    notifyListeners();
  }

  void setChecklist(List<String> list) {
    checklist = list;
    storeSettings();
    notifyListeners();
  }

  void setTheme(ThemeMode mode) {
    theme = mode;
    storeSettings();
    notifyListeners();
  }

  void setShowAnimalImages(bool state) {
    showAnimalImages = state;
    storeSettings();
    notifyListeners();
  }

  bool isHiddenAnimal(String name) {
    return hiddenAnimals.contains(name);
  }

  void hideAnimal(String name) {
    hiddenAnimals.add(name);
    setHiddenAnimals(hiddenAnimals);
  }

  void setHiddenAnimals(Iterable<String> names) {
    hiddenAnimals = names.toList();
    storeSettings();
    notifyListeners();
  }
}
