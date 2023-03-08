import 'package:flutter/foundation.dart';
import 'package:totem_app/model/totem_data.dart';
import 'package:azlistview/azlistview.dart';

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

  List<TotemResult> apply(Iterable<AnimalData> animals) {
    return animals
        .map((a) => TotemResult(
            a, a.traits.toSet().intersection(selectedTraits).length))
        .where((e) => e.score > 0)
        .toList()
      ..sort((a, b) => b.score - a.score);
  }
}

class TotemResult extends ISuspensionBean {
  final AnimalData animal;
  final int score;

  TotemResult(this.animal, this.score);

  @override
  String getSuspensionTag() {
    var tag = animal.name.substring(0, 1).toUpperCase();
    if (RegExp("[A-Z]").hasMatch(tag)) {
      return tag;
    } else {
      return "#";
    }
  }
}
