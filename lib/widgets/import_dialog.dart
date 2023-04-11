import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:totemapp/model/dynamic_data.dart';
import 'package:totemapp/model/profile_manager.dart';

class ImportDialog extends StatefulWidget {
  const ImportDialog({super.key, required this.onSubmitted, this.code});

  final void Function(ProfileData) onSubmitted;
  final String? code;

  @override
  State<ImportDialog> createState() => _ImportDialogState();
}

class _ImportDialogState extends State<ImportDialog> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final dynamicData = context.watch<DynamicData>();
    final profiles = context.watch<ProfileManager>().profiles;

    return SimpleDialog(
      title: const Text('Importeer profiel'),
      contentPadding: const EdgeInsets.all(12),
      children: [
        Form(
            key: _formKey,
            child: TextFormField(
                onFieldSubmitted: (code) {
                  final profile = ProfileData.decode(code, dynamicData);
                  if (profiles.map((p) => p.name).contains(profile.name)) {
                    final parentContext = context;
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('${profile.name} overschrijven?'),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Navigator.pop(parentContext);
                                  },
                                  child: const Text('Annuleren')),
                              TextButton(
                                  onPressed: () {
                                    widget.onSubmitted(profile);
                                    Navigator.pop(context);
                                    Navigator.pop(parentContext);
                                  },
                                  child: const Text('Overschrijven')),
                            ],
                          );
                        });
                  } else {
                    widget.onSubmitted(profile);
                    Navigator.pop(context);
                  }
                },
                autofocus: true,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                    labelText: 'Code', border: OutlineInputBorder()))),
      ],
    );
  }
}
