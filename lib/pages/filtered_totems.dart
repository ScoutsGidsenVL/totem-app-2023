import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:totem_app/model/dynamic_data.dart';
import 'package:totem_app/model/traits_filter.dart';
import 'package:totem_app/widgets/animal_entry.dart';

class FilteredTotems extends StatelessWidget {
  const FilteredTotems({super.key});

  @override
  Widget build(BuildContext context) {
    final animals = context.watch<DynamicData>().animals?.values.toList() ?? [];
    final filter = context.watch<TraitsFilter>();
    final filteredAnimals = filter.apply(animals);

    return Scaffold(
        body: Column(children: [
      Expanded(
          child: Scrollbar(
              child: ListView.builder(
                  itemCount: filteredAnimals.length,
                  itemBuilder: (context, index) {
                    var e = filteredAnimals[index];
                    return AnimalEntry(animal: e.animal, score: e.score);
                  }))),
      filter.isEmpty
          ? Container()
          : Material(
              color: Theme.of(context).colorScheme.primary,
              child: Row(children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 12),
                    child: Text(
                        '${filteredAnimals.length} ${filteredAnimals.length == 1 ? 'resultaat' : 'resultaten'}',
                        style: const TextStyle(color: Colors.white)),
                  ),
                ),
                FilledButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Row(
                    children: [
                      Icon(Icons.arrow_back,
                          color: Theme.of(context).colorScheme.onPrimary),
                      const Text('KIES EIGENSCHAPPEN',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w300)),
                    ],
                  ),
                ),
              ]),
            )
    ]));
  }
}
