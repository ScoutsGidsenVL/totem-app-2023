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
    return traits.values.where((state) => state.isSelected).length;
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
    final traitsByState = Map.fromEntries(TraitState.values.map((state) {
      return MapEntry(
          state,
          traits.entries
              .where((e) => e.value == state)
              .map((e) => e.key)
              .toSet());
    }));
    return animals
        .map((animal) {
          final traits = animal.traits.toSet();
          return TotemResult(
              animal,
              traitsByState.entries
                  .map((e) =>
                      e.key.filterScore * traits.intersection(e.value).length)
                  .sum);
        })
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
  positive(2, Colors.green, Icons.keyboard_double_arrow_up),
  related(1, Colors.lightGreen, Icons.expand_less),
  neutral(0, Colors.grey, Icons.remove),
  negative(-5, Colors.red, Icons.keyboard_double_arrow_down);

  const TraitState(this.score, this.color, this.icon);

  final int score;
  final MaterialColor color;
  final IconData icon;

  bool get isPositive {
    return this == TraitState.related || this == TraitState.positive;
  }

  bool get isStrong {
    return this == TraitState.negative || this == TraitState.positive;
  }

  bool get isSelected {
    return Eigenschappen.simple ? isPositive : this != TraitState.neutral;
  }

  int get filterScore {
    return Eigenschappen.simple ? (isPositive ? 1 : 0) : score;
  }

  factory TraitState.fromProperties(bool positive, bool strong) {
    return positive
        ? strong
            ? TraitState.positive
            : TraitState.related
        : strong
            ? TraitState.negative
            : TraitState.neutral;
  }
}
