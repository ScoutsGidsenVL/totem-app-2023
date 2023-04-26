import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:totemapp/model/dynamic_data.dart';
import 'package:totemapp/model/settings_data.dart';
import 'package:totemapp/model/totem_data.dart';
import 'package:totemapp/widgets/animal_star_button.dart';
import 'package:totemapp/widgets/animal_preview_card.dart';
import 'package:totemapp/widgets/traits_list.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AnimalCard extends StatefulWidget {
  final AnimalData animal;
  final List<AnimalData>? swipeList;

  const AnimalCard({super.key, required this.animal, this.swipeList});

  @override
  State<AnimalCard> createState() => _AnimalCardState();
}

class _AnimalCardState extends State<AnimalCard> {
  late AnimalData _animal;
  bool _hidden = false;

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

  void toggleHidden() {
    setState(() {
      _hidden = !_hidden;
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
    final settings = context.watch<SettingsData>();

    return DraggableScrollableSheet(
        expand: false,
        builder: (context, controller) {
          return Column(
            children: [
              SingleChildScrollView(
                  controller: controller,
                  child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ..._hidden
                                ? [
                                    Expanded(
                                        child: Text('...',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineMedium)),
                                  ]
                                : [
                                    Text('${_animal.id.toString()}. ',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineMedium
                                            ?.copyWith(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary)),
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
                                  ],
                            IconButton(
                                onPressed: toggleHidden,
                                icon: Icon(_hidden
                                    ? Icons.visibility_off
                                    : Icons.visibility)),
                            AnimalStarButton(
                                animal: _animal.name, hidden: _hidden),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 8),
                          child: Image(
                              image:
                                  AssetImage('assets/images/separation.png')),
                        ),
                      ]))),
              Expanded(
                child: SingleChildScrollView(
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
                        padding: const EdgeInsets.only(
                            left: 10, right: 10, bottom: 5),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: Text(
                                      _hidden
                                          ? _animal.description
                                              .replaceAll(_animal.name, '...')
                                          : _animal.description,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium)),
                              TraitsList(_animal.traits, interactive: true),
                              if (!_hidden && settings.showAnimalImages)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(5),
                                      child: CachedNetworkImage(
                                          imageUrl: _animal.image)),
                                ),
                              if (similarAnimals.isNotEmpty)
                                Padding(
                                    padding: const EdgeInsets.only(
                                        top: 32, bottom: 8),
                                    child: Text('Totems met dezelfde kenmerken',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge)),
                              ...similarAnimals.map((a) => AnimalPreviewCard(
                                  animal: a,
                                  hidden: _hidden,
                                  onPressed: () {
                                    setState(() {
                                      _animal = a;
                                    });
                                    controller.jumpTo(0);
                                  })),
                            ]),
                      )),
                ),
              ),
            ],
          );
        });
  }
}
