import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:totemapp/model/dynamic_data.dart';
import 'package:totemapp/model/profile_manager.dart';
import 'package:totemapp/widgets/profile_card.dart';

class ImportProfile extends StatefulWidget {
  const ImportProfile({required this.code, super.key});

  final String code;

  @override
  State<ImportProfile> createState() => _ImportProfileState();
}

class _ImportProfileState extends State<ImportProfile> {
  ProfileData? _profile;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final dynamicData = context.read<DynamicData>();
      try {
        final decoded = ProfileData.decode(widget.code, dynamicData);
        setState(() {
          _profile = decoded;
        });
      } catch (e) {
        // empty catch
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final manager = context.watch<ProfileManager>();
    final isOverwrite = manager.profiles.any((p) => p.name == _profile?.name);

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: _profile == null
            ? []
            : [
                ProfileCard(_profile, canOverwrite: true),
                FilledButton.icon(
                    onPressed: () {
                      manager.selectedName = _profile!.name;
                      manager.addProfile(_profile!, force: true);
                      context.beamToNamed('/profielen');
                    },
                    icon: const Icon(Icons.person_add),
                    label: Text(
                        'Profiel ${isOverwrite ? 'overschrijven' : 'importeren'}')),
                if (isOverwrite)
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: Icon(Icons.warning_amber,
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant),
                      ),
                      Flexible(
                        child: Text(
                            'Er bestaal al een profiel met de naam ${_profile!.name}!',
                            style: Theme.of(context).textTheme.bodySmall),
                      )
                    ],
                  ),
              ],
      ),
    );
  }
}
