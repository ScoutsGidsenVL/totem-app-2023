import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:totem_app/model/profile_manager.dart';
import 'package:totem_app/model/totem_data.dart';
import 'package:totem_app/pages/totem_detail.dart';
import 'package:totem_app/widgets/animal_star_button.dart';

class AnimalEntry extends StatelessWidget {
  final AnimalData animal;
  final int? score;

  const AnimalEntry({super.key, required this.animal, this.score});

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<ProfileManager>().profile;

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
        trailing:
            profile == null ? null : AnimalStarButton(animal: animal.name));
  }
}
