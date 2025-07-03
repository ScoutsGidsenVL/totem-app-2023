import 'package:flutter/material.dart';

class AnimalChip extends StatelessWidget {
  const AnimalChip({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Chip(
        label: Text(
          'Nieuw',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSecondary,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        visualDensity: VisualDensity.compact,
      ),
    );
  }
}
