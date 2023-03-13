import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:totem_app/model/dynamic_data.dart';
import 'package:totem_app/model/profile_manager.dart';
import 'package:totem_app/widgets/animal_star_button.dart';
import 'package:totem_app/widgets/animal_card.dart';

class TotemDetail extends StatelessWidget {
  final String name;

  const TotemDetail({Key? key, required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var animal = context.watch<DynamicData>().animals?[name];
    final profile = context.watch<ProfileManager>().profile;

    return Scaffold(
        appBar: AppBar(
          title: const Text('Beschrijving'),
          actions: profile == null ? [] : [AnimalStarButton(animal: name)],
        ),
        body: ListView(
          padding: const EdgeInsets.all(10),
          children: [animal == null ? Container() : AnimalCard(animal: animal)],
        ));
  }
}

class TotemDetailArguments {
  final String name;

  TotemDetailArguments(this.name);
}
