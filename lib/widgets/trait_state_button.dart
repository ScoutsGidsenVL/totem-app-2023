import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:totemapp/model/dynamic_data.dart';
import 'package:totemapp/model/totem_data.dart';
import 'package:totemapp/model/traits_filter.dart';

class TraitStateButton extends StatelessWidget {
  final TraitData trait;
  final TraitState targetState;
  final bool cascade;
  final bool force;

  const TraitStateButton(this.trait, this.targetState,
      {super.key, this.cascade = false, this.force = false});

  @override
  Widget build(BuildContext context) {
    final allTraits = context.watch<DynamicData>().traits ?? {};
    final filter = context.watch<TraitsFilter>();
    final currentState = filter.getState(trait.name);
    final active = targetState == currentState;

    return IconButton(
        onPressed: () {
          filter.updateTraits(Map.fromEntries([
            MapEntry(trait.name, active ? TraitState.neutral : targetState),
            ...cascade && (targetState == TraitState.positive || force)
                ? trait.synonyms.expand((s) {
                    final synonymState = filter.getState(s);
                    if (!allTraits.containsKey(s)) return [];
                    if (force) {
                      return [
                        MapEntry(s, active ? TraitState.neutral : targetState)
                      ];
                    }
                    if (active && synonymState == TraitState.related) {
                      return [MapEntry(s, TraitState.neutral)];
                    }
                    if (!active && synonymState == TraitState.neutral) {
                      return [MapEntry(s, TraitState.related)];
                    }
                    return [];
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
