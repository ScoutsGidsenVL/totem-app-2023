import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:totem_app/model/loaded_profile.dart';

class ProfileEntry extends StatelessWidget {
  final ProfileData profile;

  const ProfileEntry({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    var loadedProfile = context.watch<LoadedProfile>();

    return ListTile(
        onTap: () {
          if (loadedProfile.profile?.name == profile.name) {
            loadedProfile.unselectProfile();
          } else {
            loadedProfile.selectProfile(profile.name);
          }
        },
        onLongPress: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('${profile.name} verwijderen?'),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Annuleren')),
                    TextButton(
                        onPressed: () {
                          loadedProfile.deleteProfile(profile.name);
                          Navigator.pop(context);
                        },
                        child: const Text('Verwijderen'))
                  ],
                );
              });
        },
        leading: Icon(loadedProfile.profile?.name == profile.name
            ? Icons.check_circle
            : Icons.circle_outlined),
        title: Text(profile.name));
  }
}
