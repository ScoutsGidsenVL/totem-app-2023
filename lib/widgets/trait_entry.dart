import 'package:flutter/material.dart';
import 'package:totemapp/model/totem_data.dart';
import 'package:totemapp/model/traits_filter.dart';
import 'package:totemapp/widgets/trait_card.dart';
import 'package:totemapp/widgets/trait_state_button.dart';

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
    return ListTile(
      onTap: nested ? null : () => showCard(context),
      key: Key(trait.name),
      contentPadding:
          nested ? null : const EdgeInsets.only(left: 16, right: 32),
      title: Text(trait.name, style: const TextStyle(fontSize: 20)),
      trailing: Row(mainAxisSize: MainAxisSize.min, children: [
        TraitStateButton(trait, TraitState.negative),
        TraitStateButton(trait, TraitState.related),
        TraitStateButton(trait, TraitState.positive),
      ]),
    );
  }
}
