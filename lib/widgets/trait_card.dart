import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:totemapp/model/dynamic_data.dart';
import 'package:totemapp/model/totem_data.dart';
import 'package:totemapp/model/traits_filter.dart';
import 'package:totemapp/widgets/traits_list.dart';

class TraitCard extends StatelessWidget {
  final TraitData trait;

  const TraitCard({super.key, required this.trait});

  @override
  Widget build(BuildContext context) {
    final allTraits = context.watch<DynamicData>().traits?.keys.toList() ?? [];
    final filter = context.watch<TraitsFilter>();

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
                      padding: const EdgeInsets.all(10),
                      child: Text(trait.name)),
                  Padding(
                      padding: const EdgeInsets.all(10),
                      child: TraitsList(trait.synonyms, icon: Icons.menu_book)),
                  ...trait.synonyms.where((e) => allTraits.contains(e)).map(
                      (e) => CheckboxListTile(
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding:
                              const EdgeInsets.only(left: 16, right: 32),
                          activeColor: Theme.of(context).colorScheme.primary,
                          value: filter.isSelected(e),
                          onChanged: (enabled) {
                            filter.selectTrait(e, enabled ?? false);
                          },
                          title: Text(e))),
                ]),
          );
        });
  }
}
