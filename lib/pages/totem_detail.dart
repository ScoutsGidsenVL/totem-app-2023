import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:totem_app/model/dynamic_data.dart';
import 'package:totem_app/widgets/animal_card.dart';

class TotemDetail extends StatelessWidget {
  final String name;

  const TotemDetail({Key? key, required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final animal = context.watch<DynamicData>().animals?[name];

    return Scaffold(
        body: ListView(padding: const EdgeInsets.all(10), children: [
      animal == null ? Container() : AnimalCard(animal: animal)
    ]));
  }
}

class TotemDetailArguments {
  final String name;

  TotemDetailArguments(this.name);
}
