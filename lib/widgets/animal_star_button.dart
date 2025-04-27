import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:totemapp/model/profile_manager.dart';
import 'package:totemapp/model/traits_filter.dart';
import 'package:totemapp/util.dart';
import 'package:totemapp/widgets/profile_dialog.dart';

class AnimalStarButton extends StatelessWidget {
  static final color = Colors.amber.shade600;

  const AnimalStarButton({
    super.key,
    required this.animal,
    this.hidden = false,
  });

  final String animal;
  final bool hidden;

  @override
  Widget build(BuildContext context) {
    final profileManager = context.watch<ProfileManager>();
    final profiles = profileManager.profiles;
    final profile = profileManager.profile;
    final starred = profile == null
        ? profiles.any((p) => p.animals.contains(animal))
        : profile.animals.contains(animal);

    return IconButton(
        onPressed: () {
          if (profile != null) {
            profileManager.toggleAnimal(profile, animal, !starred);
            if (starred) {
              showUndo(context,
                  '${hidden ? '...' : animal} verwijderd van ${profile.name}',
                  () {
                profileManager.toggleAnimal(profile, animal, true);
              });
            }
            return;
          }
          showDialog(
              context: context,
              builder: (context) {
                return SimpleDialog(
                    title: Text('Voeg ${hidden ? '...' : animal} toe aan'),
                    contentPadding: const EdgeInsets.all(12),
                    children: [
                      ...profiles.map((profile) {
                        final starred = profile.animals.contains(animal);
                        return SimpleDialogOption(
                          onPressed: () {
                            profileManager.toggleAnimal(
                                profile, animal, !starred);
                            if (starred) {
                              showUndo(context,
                                  '${hidden ? '...' : animal} verwijderd van ${profile.name}',
                                  () {
                                profileManager.toggleAnimal(
                                    profile, animal, true);
                              });
                            }
                            Navigator.pop(context);
                          },
                          child: Row(children: [
                            Icon(starred ? Icons.star : Icons.star_outline,
                                color: profile.getColor(context)),
                            Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Text(profile.name)),
                          ]),
                        );
                      }),
                      SimpleDialogOption(
                        onPressed: () {
                          final parentContext = context;
                          showDialog(
                              context: context,
                              builder: (context) {
                                return ProfileDialog(
                                    onSubmitted: (name, color) {
                                  final profileTraits =
                                      Map<String, TraitState>.from(
                                          context.read<TraitsFilter>().traits);
                                  context.read<ProfileManager>().createProfile(
                                      name: name,
                                      animals: [animal],
                                      traits: profileTraits,
                                      color: color);
                                  Navigator.pop(parentContext);
                                });
                              });
                        },
                        child: const Row(children: [
                          Icon(Icons.person_add),
                          Padding(
                              padding: EdgeInsets.only(left: 8),
                              child: Text('Nieuw profiel')),
                        ]),
                      )
                    ]);
              });
          return;
        },
        color: starred ? color : null,
        icon: Icon(starred ? Icons.star : Icons.star_outline));
  }
}
