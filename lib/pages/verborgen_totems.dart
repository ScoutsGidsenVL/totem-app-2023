import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:totemapp/model/dynamic_data.dart';
import 'package:totemapp/model/settings_data.dart';
import 'package:totemapp/model/totem_data.dart';
import 'package:totemapp/util.dart';
import 'package:totemapp/widgets/animal_entry.dart';

class VerborgenTotems extends StatelessWidget {
  const VerborgenTotems({super.key});

  @override
  Widget build(BuildContext context) {
    final allAnimals = context.watch<DynamicData>().animals;
    final settings = context.watch<SettingsData>();

    final hiddenAnimals = settings.hiddenAnimals.expand((name) {
      final animal = allAnimals?[name];
      return animal == null ? <AnimalData>[] : [animal];
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Verborgen totems')),
      body: hiddenAnimals.isEmpty
          ? Center(
              child: Text('Nog geen verborgen totems',
                  style: Theme.of(context).textTheme.bodySmall))
          : ListView.builder(
              itemCount: hiddenAnimals.length,
              itemBuilder: (context, index) {
                final animal = hiddenAnimals[index];
                return AnimalEntry(
                  animal: animal,
                  swipeList: hiddenAnimals,
                  trailing: IconButton(
                      onPressed: () {
                        showUndo(
                            context, '${animal.name} is niet langer verborgen',
                            () {
                          settings.hideAnimal(animal.name);
                        });
                        settings.setHiddenAnimals(settings.hiddenAnimals
                            .where((e) => e != animal.name));
                      },
                      icon: const Icon(Icons.do_disturb_off)),
                );
              },
            ),
    );
  }
}
