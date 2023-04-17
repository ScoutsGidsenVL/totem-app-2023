import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:totemapp/model/traits_filter.dart';

class TraitsList extends StatelessWidget {
  const TraitsList(this.traits,
      {super.key, this.icon, this.interactive = false});

  final List<String> traits;
  final IconData? icon;
  final bool interactive;

  @override
  Widget build(BuildContext context) {
    final filter = context.watch<TraitsFilter>();

    return InkWell(
      onTap: !interactive || filter.isEmpty
          ? null
          : () {
              showDialog(
                  context: context,
                  builder: (context) {
                    final filter = context.watch<TraitsFilter>();
                    return SimpleDialog(
                        children: traits
                            .map((trait) => CheckboxListTile(
                                title: Text(trait,
                                    style: const TextStyle(fontSize: 20)),
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                value: filter.getState(trait).isPositive,
                                onChanged: (enabled) {
                                  filter.setState(
                                      trait, TraitState.from(enabled ?? false));
                                }))
                            .toList());
                  });
            },
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Icon(icon ?? Icons.psychology,
                color: Theme.of(context).colorScheme.onSurfaceVariant)),
        Flexible(
            child: Text(traits.map((e) => e.toLowerCase()).join(', '),
                style: Theme.of(context).textTheme.bodySmall, softWrap: true))
      ]),
    );
  }
}
