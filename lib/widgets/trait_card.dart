import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:totemapp/model/dynamic_data.dart';
import 'package:totemapp/model/totem_data.dart';
import 'package:totemapp/widgets/trait_entry.dart';
import 'package:totemapp/widgets/traits_list.dart';

class TraitCard extends StatelessWidget {
  final TraitData trait;

  const TraitCard({super.key, required this.trait});

  @override
  Widget build(BuildContext context) {
    final allTraits = context.watch<DynamicData>().traits ?? {};

    return DraggableScrollableSheet(
        expand: false,
        builder: (context, controller) {
          return SingleChildScrollView(
            controller: controller,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                      padding:
                          const EdgeInsets.only(top: 10, left: 10, right: 10),
                      child: Text(trait.name)),
                  Padding(
                      padding: const EdgeInsets.all(10),
                      child: TraitsList(trait.synonyms, icon: Icons.menu_book)),
                  ...trait.synonyms.expand((s) {
                    final synonym = allTraits[s];
                    if (synonym == null) return [];
                    return [TraitEntry(trait: synonym)];
                  }),
                ]),
          );
        });
  }
}
