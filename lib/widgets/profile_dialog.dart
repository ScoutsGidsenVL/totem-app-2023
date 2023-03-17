import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:totem_app/model/profile_manager.dart';

class ProfileDialog extends StatefulWidget {
  const ProfileDialog(
      {super.key,
      required this.onSubmitted,
      this.title,
      this.initialName,
      this.initialColor});

  final void Function(String, int) onSubmitted;
  final String? title;
  final String? initialName;
  final int? initialColor;

  @override
  State<ProfileDialog> createState() => _ProfileDialogState();
}

class _ProfileDialogState extends State<ProfileDialog> {
  late int _colorId;

  @override
  void initState() {
    super.initState();
    _colorId =
        widget.initialColor ?? Random().nextInt(ProfileData.colors.length);
  }

  void selectColor(int id) {
    setState(() {
      _colorId = id;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text(widget.title ?? 'Nieuw profiel'),
      contentPadding: const EdgeInsets.all(12),
      children: [
        TextFormField(
            initialValue: widget.initialName,
            onFieldSubmitted: (name) {
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
