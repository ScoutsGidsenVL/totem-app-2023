
import 'package:flutter/material.dart';
import 'package:totem_app/model/totem_data.dart';
import 'package:totem_app/pages/totem_detail.dart';

class AnimalEntry extends StatelessWidget {
  final AnimalData animal;
  final int? score;

  const AnimalEntry({super.key, required this.animal, this.score});

  @override
  Widget build(BuildContext context) {
    return ListTile(
        onTap: () {
          Navigator.pushNamed(context, '/totem',
              arguments: TotemDetailArguments(animal.name));
        },
        title: Row(
          children: [
            Expanded(child: Text('${animal.id.toString()}. ${animal.name}')),
            score == null ? Container() : Text(score.toString()),
          ],
        ));
  }
}
