import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:totemapp/model/dynamic_data.dart';
import 'package:totemapp/model/profile_manager.dart';
import 'package:totemapp/widgets/profile_card.dart';

class ImportProfile extends StatefulWidget {
  const ImportProfile({required this.initialCode, super.key});

  final String? initialCode;

  @override
  State<ImportProfile> createState() => _ImportProfileState();
}

class _ImportProfileState extends State<ImportProfile> {
  final FocusNode _textFocus = FocusNode();
  final TextEditingController _textController = TextEditingController();
  ProfileData? _profile;

  @override
  void initState() {
    super.initState();
    if (widget.initialCode != null) {
      _textController.text = widget.initialCode!.trim();
    } else {
      _textFocus.requestFocus();
    }
  }

  @override
  void dispose() {
    _textFocus.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _codeChanged(BuildContext context) {
    final dynamicData = context.read<DynamicData>();
    var code = _textController.text.trim();
    if (code.startsWith('https://')) {
      code = code.replaceFirst('https://totemapp.be/?p=', '');
    }
    try {
      ProfileData? decoded = ProfileData.decode(code, dynamicData);
      _textFocus.unfocus();
      if (decoded.error != null) {
        decoded = null;
      }
      setState(() {
        _profile = decoded;
      });
    } catch (e) {
      setState(() {
        _profile = null;
      });
    }
  }

  void _clearText() {
    _textController.text = '';
    _textFocus.requestFocus();
    setState(() {
      _profile = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final manager = context.watch<ProfileManager>();
    final isOverwrite = manager.profiles.any((p) => p.name == _profile?.name);

    if (manager.dynamicData != null &&
        _textController.text.isNotEmpty &&
        _profile == null) {
      _codeChanged(context);
    }

    return Scaffold(
      body: ListView(padding: const EdgeInsets.all(10), children: [
        TextField(
            focusNode: _textFocus,
            controller: _textController,
            onChanged: (_) => _codeChanged(context),
            decoration: InputDecoration(
                suffixIcon: IconButton(
                    onPressed: _clearText, icon: const Icon(Icons.close)),
                labelText: 'Link',
                border: const OutlineInputBorder())),
        if (_profile != null) ProfileCard(_profile, ephemeral: true),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: FilledButton.icon(
            onPressed: _profile == null
                ? null
                : () {
                    manager.selectedName = _profile!.name;
                    manager.addProfile(_profile!, force: true);
                    context.popToNamed('/profielen');
                  },
            icon: const Icon(Icons.person_add),
            style: _profile == null
                ? ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                        Theme.of(context).colorScheme.surfaceVariant),
                    foregroundColor: MaterialStatePropertyAll(
                        Theme.of(context).colorScheme.onSurfaceVariant))
                : null,
            label:
                Text('Profiel ${isOverwrite ? 'overschrijven' : 'toevoegen'}'),
          ),
        ),
        if (_profile != null && isOverwrite)
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 5),
                child: Icon(Icons.warning_amber,
                    color: Theme.of(context).colorScheme.onSurfaceVariant),
              ),
              Flexible(
                child: Text('Er bestaal al een profiel met deze naam!',
                    style: Theme.of(context).textTheme.bodySmall),
              )
            ],
          ),
      ]),
    );
  }
}
