import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:totem_app/model/profile_manager.dart';
import 'package:totem_app/widgets/profile_dialog.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard(this.profile, {super.key});

  final ProfileData profile;

  @override
  Widget build(BuildContext context) {
    var manager = context.watch<ProfileManager>();

    return Card(
        child: Padding(
      padding: const EdgeInsets.all(5),
      child: Column(
        children: [
          Row(children: [
            Icon(Icons.account_circle, size: 48, color: profile.color.shade700),
            Expanded(
                child: Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Text(profile.name,
                        style: const TextStyle(fontSize: 22)))),
            IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return ProfileDialog(
                            onSubmitted: (name, color) {
                              manager.updateProfile(() {
                                profile.name = name;
                                profile.colorId = color;
                                manager.selectedName = name;
                              });
                            },
                            title: 'Profiel bewerken',
                            initialName: profile.name,
                            initialColor: profile.colorId);
                      });
                },
                icon: const Icon(Icons.edit)),
            IconButton(
                onPressed: () {
                  manager.unselectProfile();
                },
                icon: const Icon(Icons.close))
          ]),
          if (profile.animals.isNotEmpty)
            Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Icon(Icons.star,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant)),
                      Flexible(
                          child: Text(profile.animals.join(', '),
                              style: Theme.of(context).textTheme.bodySmall,
                              softWrap: true))
                    ])),
          if (profile.traits.isNotEmpty)
            Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Icon(Icons.psychology,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant)),
                      Flexible(
                          child: Text('${profile.traits.length} eigenschappen',
                              style: Theme.of(context).textTheme.bodySmall,
                              softWrap: true))
                    ]))
        ],
      ),
    ));
  }
}
