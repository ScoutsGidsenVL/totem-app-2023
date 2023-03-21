import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:totemapp/model/totem_data.dart';
import 'package:totemapp/model/traits_filter.dart';

class TraitStateButton extends StatelessWidget {
  final TraitData trait;
  final TraitState targetState;

  const TraitStateButton(this.trait, this.targetState, {super.key});

  @override
  Widget build(BuildContext context) {
    final filter = context.watch<TraitsFilter>();
    final currentState = filter.getState(trait.name);
    final isSelected = targetState == currentState;

    return IconButton(
        onPressed: () {
          filter.updateTraits(Map.fromEntries([
            MapEntry(trait.name, isSelected ? TraitState.neutral : targetState),
            ...targetState == TraitState.positive
                ? trait.synonyms.expand((s) {
                    final synonymState = filter.getState(s);
                    if (isSelected && synonymState == TraitState.related) {
                      return [MapEntry(s, TraitState.neutral)];
                    }
                    if (!isSelected && synonymState == TraitState.neutral) {
                      return [MapEntry(s, TraitState.related)];
                    }
                    return [];
                  })
                : [],
          ]));
        },
        icon: Container(
          decoration: isSelected
              ? BoxDecoration(
                  shape: BoxShape.circle, color: targetState.color.shade200)
              : null,
          child: Icon(targetState.icon,
              color: isSelected ? targetState.color.shade600 : null),
        ));
  }
}
