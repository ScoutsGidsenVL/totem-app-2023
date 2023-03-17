import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChecklistData extends ChangeNotifier {
  List<String> checked = [];

  ChecklistData() {
    loadChecklist();
  }

  Future loadChecklist() async {
    final prefs = await SharedPreferences.getInstance();
    checked = prefs.getStringList('checklist') ?? [];
    notifyListeners();
  }

  Future storeChecklist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('checklist', checked);
  }

  bool isChecked(String name) {
    return checked.contains(name);
  }

  void toggleCheck(String name) {
    if (checked.contains(name)) {
      checked.removeWhere((e) => e == name);
    } else {
      checked.add(name);
    }
    storeChecklist();
    notifyListeners();
  }

  void reset() {
    checked.clear();
    storeChecklist();
    notifyListeners();
  }
}
