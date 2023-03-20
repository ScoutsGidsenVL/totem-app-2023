import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:totemapp/model/totem_data.dart';

const dataRepo =
    'https://raw.githubusercontent.com/ScoutsGidsenVL/totem-app-2023/main';

class DynamicData extends ChangeNotifier {
  Map<String, AnimalData>? animals;
  Map<String, TraitData>? traits;
  Map<int, AnimalData>? animalsById;
  Map<int, TraitData>? traitsById;
  Map<String, List<String>>? traitToAnimals;
  Map<String, String> text = {};

  DynamicData() {
    refreshData();
  }

  Future refreshData() async {
    await Future.wait([
      refreshTotemData(),
      refreshText('checklist'),
    ]);
    notifyListeners();
  }

  Future refreshTotemData() async {
    var source = await fetchAsset('content/totems.json');
    var data = await json.decode(source);
    var totemData = TotemData.fromJson(data);

    var allAnimals = totemData.animals;
    animals = Map.fromEntries(allAnimals.map((a) => MapEntry(a.name, a)));
    animalsById = Map.fromEntries(allAnimals.map((a) => MapEntry(a.id, a)));

    var allTraits = totemData.traits;
    traits = Map.fromEntries(allTraits.map((t) => MapEntry(t.name, t)));
    traitsById = Map.fromEntries(allTraits.map((t) => MapEntry(t.id, t)));

    traitToAnimals =
        Map.fromEntries(allTraits.map((t) => MapEntry(t.name, [])));
    for (var animal in allAnimals) {
      for (var trait in animal.traits) {
        traitToAnimals![trait]!.add(animal.name);
      }
    }
  }

  Future refreshText(String key) async {
    text[key] = await fetchAsset('content/$key.md');
  }

  Future<String> fetchAsset(String path) async {
    try {
      if (kDebugMode) {
        throw Exception("Always read from the local bundle in debug mode");
      }
      var manager = DefaultCacheManager();
      var url = '$dataRepo/assets/$path';
      try {
        // First try to fetch the most recent version
        var fileInfo = await manager.downloadFile(url);
        return await fileInfo.file.readAsString();
      } catch (e) {
        // If that fails get the cached version
        var file = await manager.getSingleFile(url);
        return await file.readAsString();
      }
    } catch (e) {
      // If that fails read from the app bundle
      return await rootBundle.loadString('assets/$path');
    }
  }
}
