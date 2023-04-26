import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:totemapp/model/dynamic_data.dart';
import 'package:totemapp/model/settings_data.dart';
import 'package:totemapp/model/traits_filter.dart';
import 'package:totemapp/widgets/animal_entry.dart';

class FilteredTotems extends StatelessWidget {
  const FilteredTotems({super.key});

  @override
  Widget build(BuildContext context) {
    final allAnimals =
        context.watch<DynamicData>().animals?.values.toList() ?? [];
    final filter = context.watch<TraitsFilter>();
    final settings = context.watch<SettingsData>();
    final animals = filter
        .apply(allAnimals)
        .where((a) => !settings.isHiddenAnimal(a.animal.name))
        .toList();

    if (filter.isEmpty) {
      Future.microtask(() => Navigator.popUntil(context, (r) => r.isFirst));
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
                      swipeList: animals.map((e) => e.animal).toList(),
                      score: e.score,
                      actions: [
                        OutlinedButton.icon(
                          onPressed: () {
                            settings.hideAnimal(e.animal.name);
                          },
                          icon: const Icon(Icons.remove_circle),
                          label: const Text('Deze totem niet meer voorstellen'),
                        )
                      ],
                    );
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
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary)),
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
                      Text('KIES EIGENSCHAPPEN',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary)),
                    ],
                  ),
                ),
              ]),
            )
    ]));
  }
}
