import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:totem_app/model/profile_manager.dart';

class ProfileEntry extends StatelessWidget {
  final ProfileData profile;

  const ProfileEntry({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    final manager = context.watch<ProfileManager>();

    return ListTile(
        contentPadding: const EdgeInsets.only(left: 16, right: 32),
        onTap: () {
          manager.selectProfile(profile.name);
        },
        title: Text(profile.name),
        trailing: IconButton(
            onPressed: () {
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
                              manager.deleteProfile(profile.name);
                              Navigator.pop(context);
                            },
                            child: const Text('Verwijderen'))
                      ],
                    );
                  });
            },
            icon: const Icon(Icons.delete)));
  }
}
