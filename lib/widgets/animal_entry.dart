import 'package:flutter/material.dart';
import 'package:totemapp/model/totem_data.dart';
import 'package:totemapp/widgets/animal_card.dart';
import 'package:totemapp/widgets/animal_chip.dart';
import 'package:totemapp/widgets/animal_name.dart';
import 'package:totemapp/widgets/animal_star_button.dart';

class AnimalEntry extends StatelessWidget {
  final AnimalData animal;
  final bool padRight;
  final List<AnimalData>? swipeList;
  final double? score;
  final Widget? trailing;
  final List<Widget> actions;

  const AnimalEntry({
    super.key,
    required this.animal,
    this.padRight = false,
    this.swipeList,
    this.score,
    this.trailing,
    this.actions = const [],
  });

  @override
  Widget build(BuildContext context) {
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
                return AnimalCard(
                    animal: animal, swipeList: swipeList, actions: actions);
              });
        },
        title: Row(
          children: [
            Expanded(child: AnimalName(animal)),
            if (animal.isNew)
              AnimalChip()
          ],
        ),
        trailing: trailing ??
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (score != null)
                  Text('${(score! * 100).round()}%',
                      style: Theme.of(context).textTheme.bodySmall),
                AnimalStarButton(animal: animal.name),
              ],
            ));
  }
}
