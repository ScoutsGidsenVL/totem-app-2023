import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:totem_app/model/profile_manager.dart';
import 'package:totem_app/util.dart';
import 'package:totem_app/widgets/profile_dialog.dart';

final starColor = Colors.amber.shade600;

class AnimalStarButton extends StatelessWidget {
  const AnimalStarButton({
    super.key,
    required this.animal,
  });

  final String animal;

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
              showUndo(context, '$animal verwijderd van ${profile.name}', () {
                profileManager.toggleAnimal(profile, animal, true);
              });
            }
            return;
          }
          showDialog(
              context: context,
              builder: (context) {
                return SimpleDialog(
                    title: Text('Voeg $animal toe aan'),
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
                                  '$animal verwijderd van ${profile.name}', () {
                                profileManager.toggleAnimal(
                                    profile, animal, true);
                              });
                            }
                            Navigator.pop(context);
                          },
                          child: Row(children: [
                            starred
                                ? Icon(Icons.star,
                                    color: profile.color.shade700)
                                : Icon(Icons.star_outline,
                                    color: profile.color.shade700),
                            Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Text(profile.name)),
                          ]),
                        );
                      }).toList(),
                      SimpleDialogOption(
                        onPressed: () {
                          final parentContext = context;
                          showDialog(
                              context: context,
                              builder: (context) {
                                return ProfileDialog(
                                    onSubmitted: (name, color) {
                                  profileManager.createProfile(name,
                                      animals: [animal], color: color);
                                  Navigator.pop(parentContext);
                                });
                              });
                        },
                        child: Row(children: const [
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
        color: starred ? starColor : null,
        icon: Icon(starred ? Icons.star : Icons.star_outline));
  }
}
