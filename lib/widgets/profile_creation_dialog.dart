import 'package:flutter/material.dart';

class ProfileCreationDialog extends StatelessWidget {
  const ProfileCreationDialog({super.key, required this.onSubmitted});

  final void Function(String) onSubmitted;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text('Nieuw profiel'),
      contentPadding: const EdgeInsets.all(12),
      children: [
        TextField(
            onSubmitted: (name) {
              if (name.isEmpty) {
                return;
              }
              onSubmitted(name);
              Navigator.pop(context);
            },
            autofocus: true,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
                labelText: 'Naam', border: OutlineInputBorder())),
      ],
    );
  }
}
