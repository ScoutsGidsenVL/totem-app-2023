import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:totemapp/model/profile_manager.dart';
import 'package:totemapp/model/tab_manager.dart';
import 'package:totemapp/model/traits_filter.dart';
import 'package:totemapp/widgets/profile_dialog.dart';
import 'package:share_plus/share_plus.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard(this.profile, {super.key});

  final ProfileData? profile;

  @override
  Widget build(BuildContext context) {
    final manager = context.watch<ProfileManager>();
    final filter = context.watch<TraitsFilter>();

    return Card(
        child: Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Row(children: [
            Icon(Icons.account_circle,
                size: 48, color: (profile?.color ?? Colors.grey).shade700),
            Flexible(
              child: Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Text(profile?.name ?? 'Nieuw profiel',
                      style: const TextStyle(fontSize: 22))),
            ),
            profile == null
                ? IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return ProfileDialog(onSubmitted: (name, color) {
                              final profileTraits =
                                  Map<String, TraitState>.from(filter.traits);
                              filter.reset();
                              context.read<ProfileManager>().createProfile(name,
                                  traits: profileTraits, color: color);
                            });
                          });
                    },
                    icon: const Icon(Icons.person_add))
                : IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return ProfileDialog(
                                onSubmitted: (name, color) {
                                  manager.updateProfile(() {
                                    profile!.name = name;
                                    profile!.colorId = color;
                                    manager.selectedName = name;
                                  });
                                },
                                title: 'Profiel bewerken',
                                initialName: profile!.name,
                                initialColor: profile!.colorId);
                          });
                    },
                    icon: const Icon(Icons.edit)),
          ]),
          if (profile?.animals.isNotEmpty ?? false)
            TextButton(
              style: const ButtonStyle(
                  shape: MaterialStatePropertyAll(RoundedRectangleBorder())),
              onPressed: () {
                manager.setShowRelevantAnimals(true);
                context.read<TabManager>().selectTabRoot(0);
              },
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Icon(Icons.star,
                        color: Theme.of(context).colorScheme.onSurfaceVariant)),
                Flexible(
                    child: Text(profile!.animals.join(', '),
                        style: Theme.of(context).textTheme.bodySmall,
                        softWrap: true))
              ]),
            ),
          TextButton(
            onPressed: () {
              manager.setShowRelevantTraits(true);
              context.read<TabManager>().selectTabRoot(1);
            },
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Icon(Icons.psychology,
                      color: Theme.of(context).colorScheme.onSurfaceVariant)),
              Flexible(
                  child: Text('${filter.selectedCount} eigenschappen',
                      style: Theme.of(context).textTheme.bodySmall,
                      softWrap: true)),
            ]),
          ),
          ...profile == null
              ? []
              : [
                  FilledButton.icon(
                      onPressed: () {
                        Share.share(profile!.encode(manager.dynamicData!));
                      },
                      style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(
                              Theme.of(context).colorScheme.surfaceVariant),
                          foregroundColor: MaterialStatePropertyAll(
                              Theme.of(context).colorScheme.onSurfaceVariant)),
                      icon: const Icon(Icons.share),
                      label: const Text('Profiel code delen')),
                  FilledButton.icon(
                      onPressed: () {
                        manager.unselectProfile();
                      },
                      style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(
                              Theme.of(context).colorScheme.surfaceVariant),
                          foregroundColor: MaterialStatePropertyAll(
                              Theme.of(context).colorScheme.onSurfaceVariant)),
                      icon: const Icon(Icons.logout),
                      label: const Text('Zonder profiel gebruiken')),
                ]
        ],
      ),
    ));
  }
}
