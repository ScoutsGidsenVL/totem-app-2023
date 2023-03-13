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
    if (dynamicData?.animalsById == null || dynamicData?.traitsById == null) {
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

  void updateProfile(Function fn) {
    fn();
    notifyListeners();
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
    addBitset(400, (i) => animals.contains(dynamicData.animalsById![i]?.name));
    addBitset(360, (i) => traits.contains(dynamicData.traitsById![i]?.name));

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

    try {
      final versionId = bytes[cursor++];
      switch (versionId) {
        case 1:
          final name = utf8.decode(getList());
          final animals = getBitset(400)
              .mapIndexed(
                  (i, b) => b ? dynamicData.animalsById![i]?.name : null)
              .whereType<String>()
              .toList();
          final traits = getBitset(360)
              .mapIndexed((i, b) => b ? dynamicData.traitsById![i]?.name : null)
              .whereType<String>()
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
