import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:totem_app/model/dynamic_data.dart';
import 'package:totem_app/model/traits_filter.dart';
import 'package:totem_app/pages/totems.dart';

class Eigenschappen extends StatefulWidget {
  const Eigenschappen({Key? key}) : super(key: key);

  @override
  State<Eigenschappen> createState() => _EigenschappenState();
}

class _EigenschappenState extends State<Eigenschappen> {
  @override
  Widget build(BuildContext context) {
    var traits = context.watch<DynamicData>().traits?.keys.toList() ?? [];
    var filter = context.watch<TraitsFilter>();

    return Scaffold(
        appBar: AppBar(
          title: const Text('Eigenschappen'),
        ),
        body: Scrollbar(
            child: ListView.builder(
                itemCount: traits.length,
                itemBuilder: (context, index) {
                  var trait = traits[index];
                  return CheckboxListTile(
                    value: filter.isSelected(trait),
                    onChanged: (enabled) =>
                        {filter.selectTrait(trait, enabled ?? false)},
                    title: Text(trait),
                    activeColor: Theme.of(context).colorScheme.primary,
                  );
                })),
        bottomSheet: filter.isEmpty
            ? null
            : Material(
                color: Theme.of(context).colorScheme.primary,
                child: Row(children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 12),
                      child: Text('${filter.length} geselecteerd',
                          style: const TextStyle(color: Colors.white)),
                    ),
                  ),
                  FilledButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/totems',
                          arguments: TotemsArguments(filtered: true));
                    },
                    child: Row(
                      children: const [
                        Text('VIND TOTEMS',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w300)),
                        Icon(Icons.arrow_forward, color: Colors.white)
                      ],
                    ),
                  )
                ]),
              ));
  }
}
