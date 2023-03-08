import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:totem_app/model/dynamic_data.dart';
import 'package:totem_app/model/traits_filter.dart';
import 'package:totem_app/pages/totem_detail.dart';

class Totems extends StatelessWidget {
  const Totems({Key? key, this.filtered}) : super(key: key);

  final bool? filtered;

  @override
  Widget build(BuildContext context) {
    var animals = context.watch<DynamicData>().animals?.values.toList() ?? [];
    var filter = filtered != true ? null : context.watch<TraitsFilter>();
    var filteredAnimals = (filter == null
            ? Map.fromEntries(animals.map((a) => MapEntry(a, 0)))
            : filter.apply(animals))
        .entries
        .toList();

    return Scaffold(
        appBar: AppBar(
          title: const Text('Totems'),
        ),
        body: Scrollbar(
            child: ListView.builder(
                itemCount: filteredAnimals.length,
                itemBuilder: (context, index) {
                  var animal = filteredAnimals[index];
                  return ListTile(
                      onTap: () {
                        Navigator.pushNamed(context, '/totem',
                            arguments: TotemDetailArguments(animal.key.name));
                      },
                      title: Row(
                        children: [
                          Expanded(
                              child: Text(
                                  '${animal.key.id.toString()}. ${animal.key.name}')),
                          animal.value == 0
                              ? Container()
                              : Text(animal.value.toString()),
                        ],
                      ));
                })));
  }
}

class TotemsArguments {
  final bool? filtered;

  TotemsArguments({this.filtered});
}
