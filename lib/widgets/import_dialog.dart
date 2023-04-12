import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';

class ImportDialog extends StatefulWidget {
  const ImportDialog({super.key});

  @override
  State<ImportDialog> createState() => _ImportDialogState();
}

class _ImportDialogState extends State<ImportDialog> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text('Importeer profiel'),
      contentPadding: const EdgeInsets.all(12),
      children: [
        Form(
            key: _formKey,
            child: TextFormField(
                onFieldSubmitted: (code) {
                  if (code.startsWith('https://')) {
                    code = code.replaceFirst('https://totemapp.be/?p=', '');
                  }
                  Navigator.pop(context);
                  Beamer.of(context, root: true)
                      .beamToNamed('/profielen/import?code=$code');
                },
                autofocus: true,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                    labelText: 'Link', border: OutlineInputBorder()))),
      ],
    );
  }
}
