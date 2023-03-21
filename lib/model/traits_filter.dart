import 'package:flutter/foundation.dart';
import 'package:totemapp/model/profile_manager.dart';
import 'package:totemapp/model/totem_data.dart';
import 'package:azlistview/azlistview.dart';

class TraitsFilter extends ChangeNotifier {
  TraitsFilter(this.profileManager, Map<String, TraitState>? selectedTraits) {
    fallbackTraits = selectedTraits ?? {};
  }

  ProfileManager? profileManager;
  late Map<String, TraitState> fallbackTraits;

  Map<String, TraitState>? get profileTraits {
    return profileManager?.profile?.traits;
  }

  Map<String, TraitState> get traits {
    return profileTraits ?? fallbackTraits;
  }

  bool get isEmpty {
    return length == 0;
  }

  int get length {
    return traits.values.where((state) => state != TraitState.neutral).length;
  }

  bool isPositive(String trait) {
    return traits[trait] == TraitState.positive;
  }

  void setTrait(String trait, TraitState state) {
    updateTraits(Map.fromEntries([MapEntry(trait, state)]));
  }

  void reset() {
    updateTraits({}, clear: true);
  }

  void updateTraits(Map<String, TraitState> traits, {bool? clear}) {
    if (profileTraits != null) {
      profileManager!.updateProfile(() {
        if (clear == true) {
          profileTraits!.clear();
        }
        for (final entry in traits.entries) {
          profileTraits![entry.key] = entry.value;
        }
      });
    } else {
      if (clear == true) {
        fallbackTraits.clear();
      }
      for (final entry in traits.entries) {
        fallbackTraits[entry.key] = entry.value;
      }
    }
    notifyListeners();
  }

  List<TotemResult> apply(Iterable<AnimalData> animals) {
    final positiveTraits = traits.entries
        .where((e) => e.value == TraitState.positive)
        .map((e) => e.key)
        .toSet();
    final negativeTraits = traits.entries
        .where((e) => e.value == TraitState.positive)
        .map((e) => e.key)
        .toSet();
    return animals
        .map((a) => TotemResult(
            a,
            a.traits.toSet().intersection(positiveTraits).length -
                2 * a.traits.toSet().intersection(negativeTraits).length))
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

enum TraitState {
  positive(1),
  neutral(0),
  negative(-1);

  const TraitState(this.score);
  final int score;
}
