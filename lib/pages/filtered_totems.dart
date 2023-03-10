import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:totem_app/model/dynamic_data.dart';
import 'package:totem_app/model/traits_filter.dart';
import 'package:totem_app/widgets/animal_entry.dart';

class FilteredTotems extends StatelessWidget {
  const FilteredTotems({super.key});

  @override
  Widget build(BuildContext context) {
    var animals = context.watch<DynamicData>().animals?.values.toList() ?? [];
    var filter = context.watch<TraitsFilter>();
    var filteredAnimals = filter.apply(animals);

    return Scaffold(
        appBar: AppBar(title: const Text('Resultaten')),
        body: Scrollbar(
            child: ListView.builder(
                itemCount: filteredAnimals.length,
                itemBuilder: (context, index) {
                  var e = filteredAnimals[index];
                  return AnimalEntry(animal: e.animal, score: e.score);
                })));
  }
}
