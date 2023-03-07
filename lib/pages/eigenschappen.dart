import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:totem_app/model/dynamic_data.dart';

class Eigenschappen extends StatefulWidget {
  const Eigenschappen({Key? key}) : super(key: key);

  @override
  State<Eigenschappen> createState() => _EigenschappenState();
}

class _EigenschappenState extends State<Eigenschappen> {
  Set<String> selectedTraits = {};

  void selectTrait(String trait, bool enabled) {
    setState(() {
      if (enabled) {
        selectedTraits.add(trait);
      } else {
        selectedTraits.remove(trait);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var traits = context.watch<DynamicData>().traits ?? [];

    return Scaffold(
        appBar: AppBar(
          title: const Text('Eigenschappen'),
        ),
        body: ListView.builder(
            itemCount: traits.length,
            itemBuilder: (context, index) {
              var trait = traits[index];
              return CheckboxListTile(
                value: selectedTraits.contains(trait),
                onChanged: (enabled) => {selectTrait(trait, enabled ?? false)},
                title: Text(trait),
              );
            }));
  }
}
