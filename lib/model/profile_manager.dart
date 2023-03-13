import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:azlistview/azlistview.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:totem_app/model/dynamic_data.dart';
import 'package:totem_app/util.dart';
import 'package:collection/collection.dart';

class ProfileManager extends ChangeNotifier {
  DynamicData? dynamicData;
  List<ProfileData> profiles = [];
  String? _selectedName;

  ProfileManager(this.dynamicData) {
    loadProfiles();
  }

  Future loadProfiles() async {
    if (dynamicData?.animalsById == null || dynamicData?.traitsById == null) {
      return;
    }
    final prefs = await SharedPreferences.getInstance();
    var encodedProfiles = prefs.getStringList('profiles') ?? [];
    var allProfiles = encodedProfiles
        .map((p) => ProfileData.decode(p, dynamicData!))
        .where((p) => p.name.isNotEmpty)
        .toList();

    // dummy profile
    allProfiles.add(ProfileData("Bob", ['Aap'], ['Behendig']));

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
    if (dynamicData?.animals == null || dynamicData?.traits == null) {
      return;
    }
    final prefs = await SharedPreferences.getInstance();
    var encodedProfiles = profiles.map((p) => p.encode(dynamicData!)).toList();
    await prefs.setStringList('profiles', encodedProfiles);
  }

  ProfileData? get profile {
    return profiles.where((p) => p.name == _selectedName).firstOrNull;
  }

  void selectProfile(String name) {
    _selectedName = name;
    notifyListeners();
  }

  void unselectProfile() {
    _selectedName = null;
    notifyListeners();
  }

  void createProfile(String name) {
    profiles.add(ProfileData(name, [], []));
    _sortProfiles();
    selectProfile(name);
    storeProfiles();
  }

  void deleteProfile(String name) {
    profiles.removeWhere((p) => p.name == name);
    unselectProfile();
    storeProfiles();
  }
}

class ProfileData extends ISuspensionBean {
  ProfileData(this.name, this.animals, this.traits);

  String name;
  List<String> animals;
  List<String> traits;

  @override
  String getSuspensionTag() {
    return getFirstLetter(name);
  }

  String encode(DynamicData dynamicData) {
    final builder = BytesBuilder();
    builder.addByte(1); // version ID

    void addList(List<int> list) {
      if (list.length > 255) list = list.sublist(0, 256);
      builder.addByte(list.length);
      builder.add(list);
    }

    var encodedName = utf8.encode(name);
    addList(encodedName);
    addList(animals.map((e) => dynamicData.animals![e]?.id ?? 0).toList());
    addList(traits.map((e) => dynamicData.traits![e]?.id ?? 0).toList());

    final bytes = builder.takeBytes();
    final str = base64.encode(bytes);
    return str;
  }

  factory ProfileData.decode(String code, DynamicData dynamicData) {
    final bytes = base64.decode(code);
    var cursor = 0;

    List<int> getList() {
      final length = bytes[cursor++];
      final list = bytes.slice(cursor, cursor + length);
      cursor += length;
      return list;
    }

    try {
      final versionId = bytes[cursor++];
      switch (versionId) {
        case 1:
          final name = utf8.decode(getList());
          final animals = getList()
              .map((e) => dynamicData.animalsById![e]?.name ?? '')
              .toList();
          final traits = getList()
              .map((e) => dynamicData.traitsById![e]?.name ?? '')
              .toList();
          return ProfileData(name, animals, traits);
        default:
          throw FormatException('Unknown profile data version $versionId');
      }
    } catch (e) {
      return ProfileData(code, [], []);
    }
  }
}
