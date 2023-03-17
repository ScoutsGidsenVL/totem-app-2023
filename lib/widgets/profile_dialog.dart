import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
  final _formKey = GlobalKey<FormState>();
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

  String? validateName(String? name, List<ProfileData> profiles) {
    if (name == null || name.trim().isEmpty) {
      return 'Geef een naam in';
    }
    if (name.trim() != widget.initialName &&
        profiles.any((p) => p.name == name.trim())) {
      return 'Naam bestaat al';
    }
    if (name.trim().length > 64) {
      return 'Naam is te lang';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final profiles = context.watch<ProfileManager>().profiles;

    return SimpleDialog(
      title: Text(widget.title ?? 'Nieuw profiel'),
      contentPadding: const EdgeInsets.all(12),
      children: [
        Form(
            key: _formKey,
            child: TextFormField(
                initialValue: widget.initialName,
                validator: (s) => validateName(s, profiles),
                onFieldSubmitted: (name) {
                  if (_formKey.currentState!.validate()) {
                    widget.onSubmitted(name.trim(), _colorId);
                    Navigator.pop(context);
                  }
                },
                autofocus: true,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                    labelText: 'Naam', border: OutlineInputBorder()))),
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
