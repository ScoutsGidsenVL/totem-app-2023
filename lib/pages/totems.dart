import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:totem_app/model/dynamic_data.dart';
import 'package:totem_app/model/totem_data.dart';
import 'package:totem_app/model/traits_filter.dart';
import 'package:azlistview/azlistview.dart';
import 'package:totem_app/widgets/animal_entry.dart';

class Totems extends StatelessWidget {
  const Totems({Key? key, this.filtered}) : super(key: key);

  final bool? filtered;

  Widget _filteredView(BuildContext context, List<AnimalData> animals) {
    var filter = context.watch<TraitsFilter>();
    var filteredAnimals = filter.apply(animals);

    return ListView.builder(
        itemCount: filteredAnimals.length,
        itemBuilder: (context, index) {
          var e = filteredAnimals[index];
          return AnimalEntry(animal: e.animal, score: e.score);
        });
  }

  @override
  Widget build(BuildContext context) {
    var animals = context.watch<DynamicData>().animals?.values.toList() ?? [];

    return Scaffold(
        appBar:
            filtered == true ? AppBar(title: const Text('Resultaten')) : null,
        body: Scrollbar(
            child: filtered == true
                ? _filteredView(context, animals)
                : AzListView(
                    data: animals,
                    itemCount: animals.length,
                    itemBuilder: (context, index) {
                      return AnimalEntry(animal: animals[index]);
                    },
                    indexBarData: SuspensionUtil.getTagIndexList(animals),
                    indexBarOptions: IndexBarOptions(
                      needRebuild: true,
                      hapticFeedback: true,
                      selectTextStyle: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.w500),
                      selectItemDecoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).colorScheme.primary),
                    ))));
  }
}

class TotemsArguments {
  final bool? filtered;

  TotemsArguments({this.filtered});
}
