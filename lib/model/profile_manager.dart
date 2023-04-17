import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:azlistview/azlistview.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:totemapp/model/dynamic_data.dart';
import 'package:totemapp/model/traits_filter.dart';
import 'package:totemapp/util.dart';
import 'package:collection/collection.dart';

class ProfileManager extends ChangeNotifier {
  static const importPrefix = 'https://totemapp.be/?p=';

  DynamicData? dynamicData;
  List<ProfileData> profiles = [];
  String? selectedName;

  bool showRelevantAnimals = false;
  bool showRelevantTraits = false;

  ProfileManager(this.dynamicData, this.selectedName) {
    loadProfiles();
  }

  Future loadProfiles() async {
    if (dynamicData?.animalsById == null || dynamicData?.traitsById == null) {
      return;
    }
    final prefs = await SharedPreferences.getInstance();
    var encodedProfiles = prefs.getStringList('profiles') ?? [];
    var allProfiles = encodedProfiles
        .expand<ProfileData>((p) {
          try {
            return [ProfileData.decode(p, dynamicData!)];
          } on Exception {
            return [];
          }
        })
        .where((p) => p.name.isNotEmpty)
        .toList();

    profiles =
        Map.fromEntries(allProfiles.map((p) => MapEntry(p.name, p)).toList())
            .values
            .toList();

    _sortProfiles();
    notifyListeners();
  }

  void _sortProfiles() {
    profiles
        .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
  }

  Future storeProfiles() async {
    if (dynamicData?.animalsById == null ||
        dynamicData?.traitsById == null ||
        dynamicData?.animals == null) {
      return;
    }
    final prefs = await SharedPreferences.getInstance();
    var encodedProfiles = profiles.map((p) => p.encode(dynamicData!)).toList();
    await prefs.setStringList('profiles', encodedProfiles);
  }

  ProfileData? get profile {
    return profiles.where((p) => p.name == selectedName).firstOrNull;
  }

  void selectProfile(String name) {
    selectedName = name;
    notifyListeners();
  }

  void unselectProfile() {
    selectedName = null;
    notifyListeners();
  }

  void createProfile(String name,
      {List<String>? animals, Map<String, TraitState>? traits, int? color}) {
    selectedName = name;
    addProfile(ProfileData(
        name, animals ?? [], traits ?? {}, color ?? ProfileData.randomColor()));
  }

  void addProfile(ProfileData profile, {bool force = false}) {
    if (profiles.any((p) => p.name == profile.name)) {
      if (force) {
        profiles.removeWhere((p) => p.name == profile.name);
      } else {
        return;
      }
    }
    profiles.add(profile);
    _sortProfiles();
    storeProfiles();
    notifyListeners();
  }

  void deleteProfile(String name) {
    if (name == selectedName) {
      selectedName = null;
    }
    profiles.removeWhere((p) => p.name == name);
    storeProfiles();
    notifyListeners();
  }

  void toggleAnimal(ProfileData profile, String animal, bool starred) {
    if (starred) {
      profile.animals.insert(0, animal);
    } else {
      profile.animals.remove(animal);
    }
    storeProfiles();
    notifyListeners();
  }

  void updateProfile(Function fn) {
    fn();
    storeProfiles();
    notifyListeners();
  }

  void setShowRelevantAnimals(bool state) {
    showRelevantAnimals = state;
    notifyListeners();
  }

  void setShowRelevantTraits(bool state) {
    showRelevantTraits = state;
    notifyListeners();
  }
}

class ProfileData extends ISuspensionBean {
  static const colors = <MaterialColor>[
    Colors.pink,
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.lime,
    Colors.green,
    Colors.teal,
    Colors.cyan,
    Colors.blue,
    Colors.indigo,
    Colors.purple,
    Colors.brown,
  ];

  static int randomColor() {
    return Random().nextInt(ProfileData.colors.length);
  }

  ProfileData(this.name, this.animals, this.traits, this.colorId)
      : assert(name.isNotEmpty),
        assert(colorId >= 0 && colorId < colors.length);

  String name;
  List<String> animals;
  Map<String, TraitState> traits;
  int colorId;

  @override
  String getSuspensionTag() {
    return getFirstLetter(name);
  }

  MaterialColor get color {
    return ProfileData.colors[colorId];
  }

  int get selectedCount {
    return traits.values.where((state) => state.isPositive).length;
  }

  String encode(DynamicData dynamicData) {
    final builder = BytesBuilder();
    builder.addByte(1); // version ID

    void addList(List<int> list) {
      if (list.length > 255) list = list.sublist(0, 256);
      builder.addByte(list.length);
      builder.add(list);
    }

    void addBitset(int length, bool Function(int) bitset) {
      assert(length % 8 == 0);
      final list = <int>[];
      for (var i = 0; i < length; i += 8) {
        int n = 0;
        if (bitset(i + 0)) n += 1;
        if (bitset(i + 1)) n += 2;
        if (bitset(i + 2)) n += 4;
        if (bitset(i + 3)) n += 8;
        if (bitset(i + 4)) n += 16;
        if (bitset(i + 5)) n += 32;
        if (bitset(i + 6)) n += 64;
        if (bitset(i + 7)) n += 128;
        list.add(n);
      }
      builder.add(list);
    }

    var encodedName = utf8.encode(name);
    addList(encodedName);

    builder.addByte(colorId);

    addList(animals.expand((a) {
      final id = dynamicData.animals![a]?.id ?? 0;
      return id <= 254 ? [id] : <int>[255, id - 254];
    }).toList());

    addBitset(
        360,
        (i) =>
            traits[dynamicData.traitsById![i + 1]?.name]?.isPositive ?? false);

    final bytes = builder.takeBytes();
    var str = base64.encode(bytes);
    while (str.endsWith('=')) {
      str = str.substring(0, str.length - 1);
    }
    return str;
  }

  factory ProfileData.decode(String code, DynamicData dynamicData) {
    try {
      if (code.startsWith(ProfileManager.importPrefix)) {
        code = code.replaceFirst(ProfileManager.importPrefix, '');
      }
      final normalized = base64.normalize(code);
      final bytes = base64.decode(normalized);
      var cursor = 0;

      List<int> getList() {
        final length = bytes[cursor++];
        final list = bytes.slice(cursor, cursor + length);
        cursor += length;
        return list;
      }

      List<bool> getBitset(int length) {
        assert(length % 8 == 0);
        final byteLength = length ~/ 8;
        final bitset = bytes.slice(cursor, cursor + byteLength);
        cursor += byteLength;
        final list = <bool>[];
        for (var i = 0; i < byteLength; i += 1) {
          int n = bitset[i];
          list.add(n & (1 << 0) > 0);
          list.add(n & (1 << 1) > 0);
          list.add(n & (1 << 2) > 0);
          list.add(n & (1 << 3) > 0);
          list.add(n & (1 << 4) > 0);
          list.add(n & (1 << 5) > 0);
          list.add(n & (1 << 6) > 0);
          list.add(n & (1 << 7) > 0);
        }
        return list;
      }

      final versionId = bytes[cursor++];
      switch (versionId) {
        case 1:
          final name = utf8.decode(getList());

          final color = bytes[cursor++];

          final animals = <String>[];
          var animalBytes = getList();
          for (var i = 0; i < animalBytes.length; i += 1) {
            var id = animalBytes[i];
            if (id == 255) {
              i += 1;
              id += animalBytes[i] - 1;
            }
            final name = dynamicData.animalsById![id]?.name;
            if (name != null) {
              animals.add(name);
            }
          }

          final isPositiveTraits = getBitset(360);
          final traits = Map.fromEntries(dynamicData.traitsById!.values
              .mapIndexed((i, trait) =>
                  MapEntry(trait.name, TraitState.from(isPositiveTraits[i]))));

          return ProfileData(name, animals, traits, color);
        default:
          throw const ProfileDecodeException(
              'Het formaat van de link is niet ondersteund, gelieve de laatste versie van de app te installeren');
      }
    } on ProfileDecodeException {
      rethrow;
    } catch (_) {
      throw const ProfileDecodeException(
          'Het formaat van de link is incorrect');
    }
  }
}

class ProfileDecodeException implements Exception {
  final String message;

  const ProfileDecodeException(this.message);
}
