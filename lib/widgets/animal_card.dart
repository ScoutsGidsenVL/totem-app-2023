import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:totem_app/model/dynamic_data.dart';
import 'package:totem_app/model/totem_data.dart';
import 'package:totem_app/widgets/animal_star_button.dart';
import 'package:totem_app/widgets/animal_preview_card.dart';

class AnimalCard extends StatefulWidget {
  final AnimalData animal;
  final List<AnimalData>? swipeList;

  const AnimalCard({super.key, required this.animal, this.swipeList});

  @override
  State<AnimalCard> createState() => _AnimalCardState();
}

class _AnimalCardState extends State<AnimalCard> {
  late AnimalData _animal;

  @override
  void initState() {
    super.initState();
    _animal = widget.animal;
  }

  void swipeAnimal(int delta) {
    if (widget.swipeList == null) {
      return;
    }
    var index = widget.swipeList!.indexOf(_animal);
    index = max(0, min(widget.swipeList!.length - 1, index + delta));
    final newAnimal = widget.swipeList![index];
    setState(() {
      _animal = newAnimal;
    });
  }

  @override
  Widget build(BuildContext context) {
    final allAnimals = context.watch<DynamicData>().animals?.values ?? [];
    final traits = _animal.traits.toSet();
    final similarAnimals = allAnimals
        .where((a) => a.name != _animal.name)
        .map((a) => MapEntry(a, a.traits.toSet().intersection(traits).length))
        .where((e) => e.value > 0)
        .sorted((a, b) => b.value - a.value)
        .map((e) => e.key)
        .take(4);

    return DraggableScrollableSheet(
        expand: false,
        builder: (context, controller) {
          return SingleChildScrollView(
              controller: controller,
              child: GestureDetector(
                  onHorizontalDragEnd: widget.swipeList == null
                      ? null
                      : (details) {
                          const sensitivity = 8;
                          final dx = details.velocity.pixelsPerSecond.dx;
                          if (dx > sensitivity) {
                            swipeAnimal(-1);
                          } else if (dx < -sensitivity) {
                            swipeAnimal(1);
                          }
                        },
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${_animal.id.toString()}. ',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium
                                      ?.copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .tertiary)),
                              Expanded(
                                  child: Text.rich(
                                      TextSpan(children: [
                                        TextSpan(
                                            text: _animal.name,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineMedium),
                                        TextSpan(
                                            text: _animal.synonyms.isEmpty
                                                ? null
                                                : ' - ${_animal.synonyms.join(', ')}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineSmall),
                                      ]),
                                      softWrap: true)),
                              AnimalStarButton(animal: _animal.name),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 8, bottom: 12),
                            child: Image(
                                image:
                                    AssetImage('assets/images/separation.png')),
                          ),
                          Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: Text(_animal.description,
                                  style:
                                      Theme.of(context).textTheme.bodyMedium)),
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                    padding: EdgeInsets.only(right: 8),
                                    child: Icon(Icons.psychology)),
                                Flexible(
                                    child: Text(_animal.traits.join(', '),
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontStyle: FontStyle.italic),
                                        softWrap: true))
                              ]),
                          similarAnimals.isEmpty
                              ? Container()
                              : Padding(
                                  padding:
                                      const EdgeInsets.only(top: 64, bottom: 8),
                                  child: Text('Totems met dezelfde kenmerken',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge)),
                          ...similarAnimals.map((a) => AnimalPreviewCard(
                              animal: a,
                              onPressed: () {
                                setState(() {
                                  _animal = a;
                                });
                                controller.jumpTo(0);
                              })),
                        ]),
                  )));
        });
  }
}
