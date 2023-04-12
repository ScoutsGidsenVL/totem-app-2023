import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:totemapp/model/profile_manager.dart';

class ProfileDialog extends StatefulWidget {
  const ProfileDialog(
      {super.key,
      required this.onSubmitted,
      this.title,
      this.initialName,
      this.initialColor,
      this.canOverwrite = false});

  final void Function(String, int) onSubmitted;
  final String? title;
  final String? initialName;
  final int? initialColor;
  final bool canOverwrite;

  @override
  State<ProfileDialog> createState() => _ProfileDialogState();
}

class _ProfileDialogState extends State<ProfileDialog> {
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late int _colorId;

  @override
  void initState() {
    super.initState();
    if (widget.initialName != null) {
      _nameController.text = widget.initialName!;
    }
    _colorId =
        widget.initialColor ?? Random().nextInt(ProfileData.colors.length);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
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
    if (!widget.canOverwrite &&
        name.trim() != widget.initialName &&
        profiles.any((p) => p.name == name.trim())) {
      return 'Naam bestaat al';
    }
    if (name.trim().length > 64) {
      return 'Naam is te lang';
    }
    return null;
  }

  void saveProfile(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      widget.onSubmitted(_nameController.text.trim(), _colorId);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final profiles = context.watch<ProfileManager>().profiles;
    final darkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    return SimpleDialog(
      title: Text(widget.title ?? 'Nieuw profiel'),
      contentPadding: const EdgeInsets.all(12),
      children: [
        Form(
            key: _formKey,
            child: TextFormField(
                controller: _nameController,
                validator: (s) => validateName(s, profiles),
                onFieldSubmitted: (name) {
                  saveProfile(context);
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
                  color: i == _colorId
                      ? (darkMode ? c.shade300 : c.shade700)
                      : (darkMode ? c.shade500 : c.shade300)));
        }).toList()),
        Padding(
          padding:
              DialogTheme.of(context).actionsPadding ?? const EdgeInsets.all(8),
          child: OverflowBar(
            alignment: MainAxisAlignment.end,
            overflowAlignment: OverflowBarAlignment.end,
            children: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Annuleren')),
              TextButton(
                  onPressed: () {
                    saveProfile(context);
                  },
                  child: const Text('Opslaan')),
            ],
          ),
        ),
      ],
    );
  }
}
