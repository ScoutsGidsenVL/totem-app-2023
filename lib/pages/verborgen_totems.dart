import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:totemapp/model/dynamic_data.dart';
import 'package:totemapp/model/settings_data.dart';
import 'package:totemapp/model/totem_data.dart';
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
      body: ListView.builder(
        itemCount: hiddenAnimals.length,
        itemBuilder: (context, index) {
          return AnimalEntry(
              animal: hiddenAnimals[index], swipeList: hiddenAnimals);
        },
      ),
    );
  }
}
