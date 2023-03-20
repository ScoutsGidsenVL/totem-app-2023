import 'package:flutter/foundation.dart';
import 'package:totemapp/model/profile_manager.dart';
import 'package:totemapp/model/totem_data.dart';
import 'package:azlistview/azlistview.dart';

class TraitsFilter extends ChangeNotifier {
  TraitsFilter(this.profileManager, Set<String>? selectedTraits) {
    fallbackTraits = selectedTraits ?? {};
  }

  ProfileManager? profileManager;
  late Set<String> fallbackTraits;

  List<String>? get profileTraits {
    return profileManager?.profile?.traits;
  }

  Set<String> get traits {
    return profileTraits?.toSet() ?? fallbackTraits;
  }

  bool get isEmpty {
    return traits.isEmpty;
  }

  int get length {
    return traits.length;
  }

  bool isSelected(String trait) {
    return traits.contains(trait);
  }

  void selectTrait(String trait, bool enabled) {
    updateTraits(Map.fromEntries([MapEntry(trait, enabled)]));
    notifyListeners();
  }

  void updateTraits(Map<String, bool> traits) {
    for (final entry in traits.entries) {
      final trait = entry.key;
      final enabled = entry.value;
      if (profileTraits != null) {
        profileManager?.updateProfile(() {
          if (enabled) {
            profileTraits!.add(trait);
          } else {
            profileTraits!.remove(trait);
          }
        });
      } else {
        if (enabled) {
          fallbackTraits.add(trait);
        } else {
          fallbackTraits.remove(trait);
        }
      }
    }
    notifyListeners();
  }

  void reset() {
    if (profileTraits != null) {
      profileManager!.updateProfile(() {
        profileTraits!.clear();
      });
    } else {
      fallbackTraits.clear();
    }
    notifyListeners();
  }

  void set(Set<String> traits) {
    if (profileTraits != null) {
      profileManager?.updateProfile(() {
        profileManager!.profile!.traits = traits.toList();
      });
    } else {
      fallbackTraits = traits;
    }
    notifyListeners();
  }

  List<TotemResult> apply(Iterable<AnimalData> animals) {
    return animals
        .map(
            (a) => TotemResult(a, a.traits.toSet().intersection(traits).length))
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
