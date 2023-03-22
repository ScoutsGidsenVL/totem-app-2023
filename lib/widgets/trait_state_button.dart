import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:totemapp/model/dynamic_data.dart';
import 'package:totemapp/model/totem_data.dart';
import 'package:totemapp/model/traits_filter.dart';

class TraitStateButton extends StatelessWidget {
  final TraitData trait;
  final TraitState targetState;
  final bool cascade;

  const TraitStateButton(this.trait, this.targetState,
      {super.key, this.cascade = false});

  @override
  Widget build(BuildContext context) {
    final allTraits = context.watch<DynamicData>().traits ?? {};
    final filter = context.watch<TraitsFilter>();
    final currentState = filter.getState(trait.name);
    final active = targetState == currentState;

    return IconButton(
        onPressed: () {
          final newState = active ? TraitState.neutral : targetState;
          filter.updateTraits(Map.fromEntries([
            MapEntry(trait.name, newState),
            ...cascade
                ? trait.synonyms.expand((s) {
                    if (!allTraits.containsKey(s)) return [];
                    return [MapEntry(s, newState)];
                  })
                : [],
          ]));
        },
        icon: Container(
          decoration: active
              ? BoxDecoration(
                  shape: BoxShape.circle, color: targetState.color.shade200)
              : null,
          child: Icon(targetState.icon,
              color: active ? targetState.color.shade600 : null),
        ));
  }
}
