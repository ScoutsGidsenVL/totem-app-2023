import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:totemapp/model/profile_manager.dart';
import 'package:totemapp/model/traits_filter.dart';
import 'package:totemapp/widgets/profile_dialog.dart';
import 'package:share_plus/share_plus.dart';
import 'package:beamer/beamer.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard(this.profile, {this.ephemeral = false, super.key});

  final ProfileData? profile;
  final bool ephemeral;

  @override
  Widget build(BuildContext context) {
    final manager = context.watch<ProfileManager>();
    final filter = context.watch<TraitsFilter>();
    final darkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    final traitCount = profile == null
        ? filter.selectedCount
        : profile!.traits.values.where((s) => s == TraitState.positive).length;

    return Card(
        child: Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Row(children: [
            Icon(Icons.account_circle,
                size: 48,
                color: (profile?.color ?? Colors.grey)[darkMode ? 400 : 700]),
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
                            return ProfileDialog(
                                onSubmitted: (name, color) {
                                  final profileTraits =
                                      Map<String, TraitState>.from(
                                          filter.traits);
                                  filter.reset();
                                  context.read<ProfileManager>().createProfile(
                                      name,
                                      traits: profileTraits,
                                      color: color);
                                },
                                ephemeral: ephemeral);
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
                                  final wasSelected =
                                      manager.selectedName == profile!.name;
                                  manager.updateProfile(() {
                                    profile!.name = name;
                                    profile!.colorId = color;
                                    if (wasSelected) {
                                      manager.selectedName = name;
                                    }
                                  });
                                },
                                title: 'Profiel bewerken',
                                initialName: profile!.name,
                                initialColor: profile!.colorId,
                                ephemeral: ephemeral);
                          });
                    },
                    icon: const Icon(Icons.edit)),
          ]),
          if (profile?.animals.isNotEmpty ?? false)
            TextButton(
              style: const ButtonStyle(
                  shape: MaterialStatePropertyAll(RoundedRectangleBorder())),
              onPressed: ephemeral
                  ? null
                  : () {
                      manager.setShowRelevantAnimals(true);
                      Beamer.of(context, root: true).beamToNamed('/totems');
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
            onPressed: ephemeral
                ? null
                : () {
                    manager.setShowRelevantTraits(true);
                    Beamer.of(context, root: true)
                        .beamToNamed('/eigenschappen');
                  },
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Icon(Icons.psychology,
                      color: Theme.of(context).colorScheme.onSurfaceVariant)),
              Flexible(
                  child: Text('$traitCount eigenschappen',
                      style: Theme.of(context).textTheme.bodySmall,
                      softWrap: true)),
            ]),
          ),
          ...profile == null
              ? []
              : [
                  FilledButton.icon(
                      onPressed: () {
                        final code = profile!.encode(manager.dynamicData!);
                        Share.share(ProfileManager.importPrefix + code);
                      },
                      style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(
                              Theme.of(context).colorScheme.surfaceVariant),
                          foregroundColor: MaterialStatePropertyAll(
                              Theme.of(context).colorScheme.onSurfaceVariant)),
                      icon: const Icon(Icons.share),
                      label: const Text('Profiel delen')),
                  if (profile == manager.profile)
                    FilledButton.icon(
                        onPressed: () {
                          manager.unselectProfile();
                        },
                        style: ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll(
                                Theme.of(context).colorScheme.surfaceVariant),
                            foregroundColor: MaterialStatePropertyAll(
                                Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant)),
                        icon: const Icon(Icons.logout),
                        label: const Text('Zonder profiel gebruiken')),
                ]
        ],
      ),
    ));
  }
}
