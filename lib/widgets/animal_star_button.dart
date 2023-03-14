import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:totem_app/model/profile_manager.dart';

class AnimalStarButton extends StatelessWidget {
  const AnimalStarButton({
    super.key,
    required this.animal,
  });

  final String animal;

  @override
  Widget build(BuildContext context) {
    final profileManager = context.watch<ProfileManager>();
    final profile = profileManager.profile;
    final starred = profile?.animals.contains(animal) ?? false;

    return IconButton(
        onPressed: () {
          if (profile == null) return;
          profileManager.updateProfile(() {
            if (starred) {
              profile.animals.remove(animal);
            } else {
              profile.animals.insert(0, animal);
            }
          });
        },
        color: starred ? Colors.amber : null,
        icon: Icon(starred ? Icons.star : Icons.star_outline));
  }
}
