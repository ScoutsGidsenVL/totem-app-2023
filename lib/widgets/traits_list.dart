import 'package:flutter/material.dart';

class TraitsList extends StatelessWidget {
  const TraitsList(this.traits, {super.key, this.icon});

  final List<String> traits;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Icon(icon ?? Icons.psychology,
              color: Theme.of(context).colorScheme.onSurfaceVariant)),
      Flexible(
          child: Text(traits.map((e) => e.toLowerCase()).join(', '),
              style: Theme.of(context).textTheme.bodySmall, softWrap: true))
    ]);
  }
}
