import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:totemapp/model/totem_data.dart';
import 'package:totemapp/model/traits_filter.dart';
import 'package:totemapp/widgets/trait_card.dart';

class TraitEntry extends StatelessWidget {
  const TraitEntry({
    super.key,
    required this.trait,
    this.nested = false,
  });

  final TraitData trait;
  final bool nested;

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
    final filter = context.watch<TraitsFilter>();
    final currentState = filter.getState(trait.name);
    return GestureDetector(
      onLongPress: nested ? null : () => showCard(context),
      child: CheckboxListTile(
          key: Key(trait.name),
          contentPadding:
              nested ? null : const EdgeInsets.only(left: 16, right: 32),
          title: Text(trait.name, style: const TextStyle(fontSize: 20)),
          controlAffinity: ListTileControlAffinity.leading,
          activeColor: Theme.of(context).colorScheme.primary,
          value: currentState.isPositive,
          onChanged: (e) {
            filter.setState(trait.name,
                e ?? false ? TraitState.positive : TraitState.neutral);
          },
          secondary: nested
              ? null
              : IconButton(
                  onPressed: () {
                    showCard(context);
                  },
                  icon: const Icon(Icons.more_vert))),
    );
  }
}
