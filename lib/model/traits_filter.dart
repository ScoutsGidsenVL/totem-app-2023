import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:totemapp/model/profile_manager.dart';
import 'package:totemapp/model/totem_data.dart';
import 'package:azlistview/azlistview.dart';
import 'package:totemapp/pages/eigenschappen.dart';

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

  int get selectedCount {
    return traits.values.where((state) => state.isPositive).length;
  }

  TraitState getState(String trait) {
    return traits[trait] ?? TraitState.neutral;
  }

  void setState(String trait, TraitState state) {
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
        .where((e) => e.value.isPositive)
        .map((e) => e.key)
        .toSet();
    return animals
        .map((animal) {
          final animalTraits = animal.traits.toSet();
          return TotemResult(
              animal,
              animalTraits.intersection(positiveTraits).length /
                  animalTraits.length);
        })
        .where((e) => e.score > 0)
        .toList()
      ..sort((a, b) => (b.score - a.score).sign.round());
  }
}

class TotemResult extends ISuspensionBean {
  final AnimalData animal;
  final double score;

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
  positive,
  neutral;

  bool get isPositive {
    return this == TraitState.positive;
  }

  int get filterScore {
    return isPositive ? 1 : 0;
  }

  factory TraitState.from(bool state) {
    return state ? TraitState.positive : TraitState.neutral;
  }
}
