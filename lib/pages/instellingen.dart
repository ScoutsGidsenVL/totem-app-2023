import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:totemapp/model/settings_data.dart';

class Instellingen extends StatelessWidget {
  const Instellingen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsData>();

    return Scaffold(
      body: ListView(
        children: [
          ListTile(
              onTap: () {
                context.beamToNamed('/instellingen/checklist');
              },
              leading: const Icon(Icons.checklist),
              trailing: const Icon(Icons.navigate_next),
              title: const Text('Totemisatie checklist',
                  style: TextStyle(fontSize: 20)),
              subtitle: const Text(
                  'Een goede, kwalitatieve totemisatie vergt tijd en inspanning. Deze handige checklist helpt je om niets te vergeten.',
                  style: TextStyle(fontSize: 18))),
          ListTile(
              leading: const Icon(Icons.dark_mode),
              trailing: DropdownButton(
                  value: settings.theme.name,
                  onChanged: (value) {
                    settings.setTheme(
                        ThemeMode.values.firstWhere((e) => e.name == value));
                  },
                  items: ThemeMode.values
                      .map((e) => DropdownMenuItem(
                          value: e.name,
                          child: Text(e == ThemeMode.light
                              ? 'Lichte modus'
                              : e == ThemeMode.dark
                                  ? 'Donkere modus'
                                  : 'Volg systeem')))
                      .toList()),
              title:
                  const Text('Donkere modus', style: TextStyle(fontSize: 20))),
          SwitchListTile(
              value: settings.showAnimalImages,
              onChanged: (enabled) {
                settings.setShowAnimalImages(enabled);
              },
              secondary: const Icon(Icons.photo),
              title: const Text('Afbeeldingen bij totems',
                  style: TextStyle(fontSize: 20))),
          ListTile(
              onTap: () {
                context.beamToNamed('/instellingen/verborgen-totems');
              },
              leading: const Icon(Icons.pets),
              trailing: const Icon(Icons.navigate_next),
              title: const Text('Verborgen totems',
                  style: TextStyle(fontSize: 20)),
              subtitle: const Text(
                  'Deze totems zullen niet voorgesteld worden in de lijst met resultaten.',
                  style: TextStyle(fontSize: 18))),
        ],
      ),
    );
  }
}
