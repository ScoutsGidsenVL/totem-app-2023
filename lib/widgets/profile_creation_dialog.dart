import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:totem_app/model/profile_manager.dart';

class ProfileCreationDialog extends StatefulWidget {
  const ProfileCreationDialog({super.key, required this.onSubmitted});

  final void Function(String, int) onSubmitted;

  @override
  State<ProfileCreationDialog> createState() => _ProfileCreationDialogState();
}

class _ProfileCreationDialogState extends State<ProfileCreationDialog> {
  late int _colorId;

  @override
  void initState() {
    super.initState();
    _colorId = Random().nextInt(ProfileData.colors.length);
  }

  void selectColor(int id) {
    setState(() {
      _colorId = id;
    });
  }

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
              widget.onSubmitted(name, _colorId);
              Navigator.pop(context);
            },
            autofocus: true,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
                labelText: 'Naam', border: OutlineInputBorder())),
        Wrap(
            children: ProfileData.colors.mapIndexed((i, c) {
          return IconButton(
              onPressed: () {
                selectColor(i);
              },
              iconSize: i == _colorId ? 32 : null,
              icon: Icon(Icons.account_circle,
                  color: i == _colorId ? c.shade700 : c.shade300));
        }).toList()),
      ],
    );
  }
}
