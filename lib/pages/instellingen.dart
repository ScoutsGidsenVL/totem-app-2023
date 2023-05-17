import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:totemapp/model/settings_data.dart';
import 'package:totemapp/model/dynamic_data.dart';
import 'package:url_launcher/url_launcher.dart';

class Instellingen extends StatelessWidget {
  const Instellingen({super.key});

  @override
  Widget build(BuildContext context) {
    final dynamicData = context.watch<DynamicData>();
    final pkg = dynamicData.packageInfo;
    final settings = context.watch<SettingsData>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Instellingen'),
      ),
      body: ListView(
        children: [
          ListTile(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return SimpleDialog(
                          title: const Text('Thema'),
                          children: [
                            SimpleDialogOption(
                              onPressed: () {
                                settings.setTheme(ThemeMode.system);
                                Navigator.pop(context);
                              },
                              child: const Text('Volg systeem'),
                            ),
                            SimpleDialogOption(
                              onPressed: () {
                                settings.setTheme(ThemeMode.light);
                                Navigator.pop(context);
                              },
                              child: const Text('Lichte modus'),
                            ),
                            SimpleDialogOption(
                              onPressed: () {
                                settings.setTheme(ThemeMode.dark);
                                Navigator.pop(context);
                              },
                              child: const Text('Donkere modus'),
                            ),
                          ]);
                    });
              },
              leading: const Icon(Icons.dark_mode),
              title: const Text('Thema', style: TextStyle(fontSize: 20)),
              subtitle: Text(
                  settings.theme == ThemeMode.light
                      ? 'Lichte modus'
                      : settings.theme == ThemeMode.dark
                          ? 'Donkere modus'
                          : 'Volg systeem',
                  style: const TextStyle(fontSize: 18))),
          SwitchListTile(
              value: settings.showAnimalImages,
              onChanged: (enabled) {
                settings.setShowAnimalImages(enabled);
              },
              secondary: const Icon(Icons.photo),
              title: const Text('Afbeeldingen bij totems',
                  style: TextStyle(fontSize: 20)),
              subtitle: const Text(
                  'Toon een afbeelding van het dier bij elke totem.',
                  style: TextStyle(fontSize: 18))),
          ListTile(
              onTap: () {
                context
                    .beamToNamed('/totemisatie/instellingen/verborgen-totems');
              },
              leading: const Icon(Icons.pets),
              trailing: const Icon(Icons.navigate_next),
              title: const Text('Verborgen totems',
                  style: TextStyle(fontSize: 20)),
              subtitle: const Text(
                  'Deze totems zullen niet voorgesteld worden in de lijst met resultaten.',
                  style: TextStyle(fontSize: 18))),
          ListTile(
            onTap: () {
              launchUrl(
                  Uri.parse('https://github.com/ScoutsGidsenVL/totem-app-2023'),
                  mode: LaunchMode.externalApplication);
            },
            leading: const Icon(Icons.info),
            title: const Text('Scouts en Gidsen Vlaanderen ©',
                style: TextStyle(fontSize: 20)),
            subtitle: Text(
                'Totemapp ${pkg == null ? '' : '${pkg.version}+${pkg.buildNumber}'}',
                style: const TextStyle(fontSize: 18)),
          )
        ],
      ),
    );
  }
}
