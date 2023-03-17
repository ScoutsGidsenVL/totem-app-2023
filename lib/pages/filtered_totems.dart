import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:totem_app/model/dynamic_data.dart';
import 'package:totem_app/model/traits_filter.dart';
import 'package:totem_app/widgets/animal_entry.dart';

class FilteredTotems extends StatelessWidget {
  const FilteredTotems({super.key});

  @override
  Widget build(BuildContext context) {
    final allAnimals =
        context.watch<DynamicData>().animals?.values.toList() ?? [];
    final filter = context.watch<TraitsFilter>();
    final animals = filter.apply(allAnimals);

    if (filter.isEmpty) {
      Future.microtask(() => Navigator.pop(context));
    }

    return Scaffold(
        body: Column(children: [
      Expanded(
          child: Scrollbar(
              child: ListView.builder(
                  itemCount: animals.length,
                  itemBuilder: (context, index) {
                    var e = animals[index];
                    return AnimalEntry(
                        animal: e.animal,
                        swipeList: animals.map((e) => e.animal).toList());
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
                        '${animals.length} ${animals.length == 1 ? 'resultaat' : 'resultaten'}',
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
