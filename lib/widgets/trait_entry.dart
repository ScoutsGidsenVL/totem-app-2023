import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:totemapp/model/dynamic_data.dart';
import 'package:totemapp/model/totem_data.dart';
import 'package:totemapp/model/traits_filter.dart';
import 'package:totemapp/widgets/trait_card.dart';

class TraitEntry extends StatelessWidget {
  const TraitEntry({
    super.key,
    required this.trait,
    this.nestable,
  });

  final TraitData trait;
  final bool? nestable;

  void showCard(BuildContext context) {
    showModalBottomSheet(
        context: context,
        enableDrag: true,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(10))),
        builder: (context) {
          return TraitCard(trait: trait);
        });
  }

  @override
  Widget build(BuildContext context) {
    final allTraits = context.watch<DynamicData>().traits?.keys.toList() ?? [];
    final filter = context.watch<TraitsFilter>();
    final isSelected = filter.isSelected(trait.name);

    return GestureDetector(
      onLongPress: nestable != true ? null : () => showCard(context),
      child: CheckboxListTile(
        key: Key(trait.name),
        controlAffinity: ListTileControlAffinity.leading,
        contentPadding: const EdgeInsets.only(left: 16, right: 32),
        value: isSelected,
        onChanged: (enabled) {
          filter.updateTraits(Map.fromEntries([
            MapEntry(trait.name, enabled ?? false),
            ...nestable != true
                ? []
                : trait.synonyms
                    .where((e) => allTraits.contains(e))
                    .map((e) => MapEntry(e, enabled ?? false)),
          ]));
        },
        title: Text(trait.name, style: const TextStyle(fontSize: 20)),
        activeColor: Theme.of(context).colorScheme.primary,
        secondary: !isSelected || trait.synonyms.isEmpty || nestable != true
            ? null
            : IconButton(
                onPressed: () => showCard(context),
                icon: const Icon(Icons.more_horiz)),
      ),
    );
  }
}
