import 'package:flutter/material.dart';
import 'package:totem_app/model/loaded_profile.dart';

class ProfileEntry extends StatelessWidget {
  final ProfileData profile;

  const ProfileEntry({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return ListTile(onTap: () {}, title: Text(profile.name));
  }
}
