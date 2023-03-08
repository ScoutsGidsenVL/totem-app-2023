import 'package:azlistview/azlistview.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:totem_app/util.dart';

class LoadedProfile extends ChangeNotifier {
  List<ProfileData> profiles = [];
  String? _loadedProfileName;

  LoadedProfile() {
    loadProfiles();
  }

  Future loadProfiles() async {
    final prefs = await SharedPreferences.getInstance();
    var encodedProfiles = prefs.getStringList('profiles') ?? [];
    profiles = encodedProfiles.map((p) => ProfileData.decode(p)).toList();

    // dummy profile
    profiles.add(ProfileData("Bob", ["Behendig"], ["Aap"]));

    notifyListeners();
  }

  Future storeProfiles() async {
    final prefs = await SharedPreferences.getInstance();
    var encodedProfiles = profiles.map((p) => p.encode()).toList();
    await prefs.setStringList('profiles', encodedProfiles);
  }

  ProfileData get profile {
    return profiles.firstWhere((p) => p.name == _loadedProfileName);
  }

  void change(String name) {
    _loadedProfileName = name;
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
    return "";
  }

  factory ProfileData.decode(String code) {
    return ProfileData("", [], []);
  }
}
