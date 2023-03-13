import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:totem_app/model/profile_manager.dart';
import 'package:totem_app/model/totem_data.dart';
import 'package:totem_app/pages/totem_detail.dart';

class AnimalEntry extends StatelessWidget {
  final AnimalData animal;
  final int? score;

  const AnimalEntry({super.key, required this.animal, this.score});

  @override
  Widget build(BuildContext context) {
    final profileManager = context.watch<ProfileManager>();
    final profile = profileManager.profile;
    final starred = profile?.animals.contains(animal.name) ?? false;

    return ListTile(
        contentPadding: const EdgeInsets.only(left: 16, right: 32),
        onTap: () {
          Navigator.pushNamed(context, '/totem-detail',
              arguments: TotemDetailArguments(animal.name));
        },
        title: Row(
          children: [
            Expanded(child: Text('${animal.id.toString()}. ${animal.name}')),
            score == null ? Container() : Text(score.toString()),
          ],
        ),
        trailing: profile == null
            ? null
            : IconButton(
                onPressed: () {
                  profileManager.updateProfile(() {
                    if (starred) {
                      profile.animals.remove(animal.name);
                    } else {
                      profile.animals.add(animal.name);
                    }
                  });
                },
                color: starred ? Colors.amber : null,
                icon: Icon(starred ? Icons.star : Icons.star_outline)));
  }
}
