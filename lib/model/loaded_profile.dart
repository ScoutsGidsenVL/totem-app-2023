import 'package:azlistview/azlistview.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:totem_app/util.dart';
import 'package:collection/collection.dart';

class LoadedProfile extends ChangeNotifier {
  List<ProfileData> profiles = [];
  String? _loadedProfileName;

  LoadedProfile() {
    loadProfiles();
  }

  Future loadProfiles() async {
    final prefs = await SharedPreferences.getInstance();
    var encodedProfiles = prefs.getStringList('profiles') ?? [];
    var allProfiles = encodedProfiles
        .map((p) => ProfileData.decode(p))
        .where((p) => p.name.isNotEmpty)
        .toList();

    // dummy profile
    allProfiles.add(ProfileData("Bob", ["Behendig"], ["Aap"]));

    profiles =
        Map.fromEntries(allProfiles.map((p) => MapEntry(p.name, p)).toList())
            .values
            .toList();

    profiles
        .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

    notifyListeners();
  }

  Future storeProfiles() async {
    final prefs = await SharedPreferences.getInstance();
    var encodedProfiles = profiles.map((p) => p.encode()).toList();
    await prefs.setStringList('profiles', encodedProfiles);
  }

  ProfileData? get profile {
    return profiles.where((p) => p.name == _loadedProfileName).firstOrNull;
  }

  void change(String name) {
    _loadedProfileName = name;
    notifyListeners();
  }

  void createProfile(String name) {
    profiles.add(ProfileData(name, [], []));
    change(name);
    storeProfiles();
  }
}

class ProfileData extends ISuspensionBean {
  ProfileData(this.name, this.traits, this.animals);

  String name;
  List<String> traits;
  List<String> animals;

  @override
  String getSuspensionTag() {
    return getFirstLetter(name);
  }

  String encode() {
    return name;
  }

  factory ProfileData.decode(String code) {
    return ProfileData(code, [], []);
  }
}
