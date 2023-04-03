import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:totemapp/model/profile_manager.dart';
import 'package:totemapp/util.dart';
import 'package:totemapp/widgets/profile_dialog.dart';
import 'package:share_plus/share_plus.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard(this.profile, {super.key});

  final ProfileData profile;

  @override
  Widget build(BuildContext context) {
    final manager = context.watch<ProfileManager>();

    return Card(
        child: Padding(
      padding: const EdgeInsets.all(10),
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
          if (profile.selectedCount > 0)
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
                          child: Text('${profile.selectedCount} eigenschappen',
                              style: Theme.of(context).textTheme.bodySmall,
                              softWrap: true))
                    ])),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Ink(
                  decoration: ShapeDecoration(
                      shape: const CircleBorder(),
                      color: Theme.of(context).colorScheme.surfaceVariant),
                  child: IconButton(
                      onPressed: () {
                        Share.share(profile.encode(manager.dynamicData!));
                      },
                      icon: const Icon(Icons.share))),
              const SizedBox(width: 10),
              Ink(
                  decoration: ShapeDecoration(
                      shape: const CircleBorder(),
                      color: Theme.of(context).colorScheme.surfaceVariant),
                  child: IconButton(
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
                      icon: const Icon(Icons.edit))),
              const SizedBox(width: 10),
              Ink(
                  decoration: ShapeDecoration(
                      shape: const CircleBorder(),
                      color: Theme.of(context).colorScheme.surfaceVariant),
                  child: IconButton(
                      onPressed: () {
                        final oldSelectedName = manager.selectedName;
                        manager.deleteProfile(profile.name);
                        showUndo(context, '${profile.name} verwijderd', () {
                          manager.selectedName = oldSelectedName;
                          manager.addProfile(profile);
                        });
                      },
                      icon: const Icon(Icons.delete))),
            ],
          ),
        ],
      ),
    ));
  }
}
