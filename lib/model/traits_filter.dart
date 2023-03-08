import 'package:flutter/foundation.dart';
import 'package:totem_app/model/totem_data.dart';

class TraitsFilter extends ChangeNotifier {
  Set<String> selectedTraits = {};

  bool get isEmpty {
    return selectedTraits.isEmpty;
  }

  int get length {
    return selectedTraits.length;
  }

  bool isSelected(String trait) {
    return selectedTraits.contains(trait);
  }

  void selectTrait(String trait, bool enabled) {
    if (enabled) {
      selectedTraits.add(trait);
    } else {
      selectedTraits.remove(trait);
    }
    notifyListeners();
  }

  Map<AnimalData, int> apply(Iterable<AnimalData> animals) {
    return Map.fromEntries(animals
        .map((a) =>
            MapEntry(a, a.traits.toSet().intersection(selectedTraits).length))
        .where((e) => e.value > 0)
        .toList()
      ..sort((a, b) => b.value - a.value));
  }
}
