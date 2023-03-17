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
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Icon(Icons.account_circle, color: profile.color.shade700),
            ),
            Flexible(
              child: Text.rich(
                  TextSpan(children: [
                    TextSpan(
                        text: profile.name,
                        style: const TextStyle(fontSize: 20)),
                    profile.animals.isEmpty
                        ? const TextSpan()
                        : TextSpan(
                            text: ' - ${profile.animals.join(', ')}',
                            style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant)),
                  ]),
                  overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
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
