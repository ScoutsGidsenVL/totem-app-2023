import 'package:flutter/material.dart';
import 'package:totemapp/model/totem_data.dart';

class AnimalName extends StatelessWidget {
  const AnimalName(this.animal, {super.key});

  final AnimalData animal;

  @override
  Widget build(BuildContext context) {
    return Text.rich(TextSpan(
      children: [
        TextSpan(text: '${animal.id.toString()}. '),
        TextSpan(text: animal.name, style: const TextStyle(fontSize: 20)),
      ],
    ));
  }
}
