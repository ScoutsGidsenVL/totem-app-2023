import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:totem_app/model/profile_manager.dart';
import 'package:totem_app/model/totem_data.dart';
import 'package:totem_app/widgets/animal_card.dart';
import 'package:totem_app/widgets/animal_star_button.dart';

class AnimalEntry extends StatelessWidget {
  final AnimalData animal;
  final int? score;
  final bool padRight;

  const AnimalEntry(
      {super.key, required this.animal, this.score, this.padRight = false});

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<ProfileManager>().profile;

    return ListTile(
        key: Key(animal.name),
        contentPadding:
            padRight ? const EdgeInsets.only(left: 16, right: 32) : null,
        onTap: () {
          showModalBottomSheet(
              context: context,
              enableDrag: true,
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(10))),
              builder: (context) {
                return DraggableScrollableSheet(
                    expand: false,
                    builder: (context, controller) {
                      return SingleChildScrollView(
                          controller: controller,
                          child: AnimalCard(animal: animal));
                    });
              });
        },
        title: Row(
          children: [
            Expanded(
                child: Text.rich(TextSpan(
              children: [
                TextSpan(text: '${animal.id.toString()}. '),
                TextSpan(
                    text: animal.name, style: const TextStyle(fontSize: 20)),
              ],
            ))),
            score == null ? Container() : Text(score.toString()),
          ],
        ),
        trailing:
            profile == null ? null : AnimalStarButton(animal: animal.name));
  }
}
