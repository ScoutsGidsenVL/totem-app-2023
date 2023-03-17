import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:totem_app/model/profile_manager.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard(this.profile, {super.key});

  final ProfileData profile;

  @override
  Widget build(BuildContext context) {
    var manager = context.watch<ProfileManager>();

    return Card(
        child: Padding(
      padding: const EdgeInsets.all(5),
      child: Row(children: [
        Icon(Icons.account_circle, size: 48, color: profile.color.shade700),
        Expanded(
            child: Padding(
                padding: const EdgeInsets.only(left: 5),
                child:
                    Text(profile.name, style: const TextStyle(fontSize: 22)))),
        IconButton(
            onPressed: () {
              manager.unselectProfile();
            },
            icon: const Icon(Icons.close))
      ]),
    ));
  }
}
