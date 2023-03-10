import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:totem_app/model/dynamic_data.dart';
import 'package:azlistview/azlistview.dart';
import 'package:totem_app/widgets/animal_entry.dart';

class Totems extends StatelessWidget {
  const Totems({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var animals = context.watch<DynamicData>().animals?.values.toList() ?? [];

    return Scaffold(
        body: Scrollbar(
            child: AzListView(
                data: animals,
                itemCount: animals.length,
                itemBuilder: (context, index) {
                  return AnimalEntry(animal: animals[index]);
                },
                indexBarData: SuspensionUtil.getTagIndexList(animals),
                indexBarOptions: IndexBarOptions(
                  needRebuild: true,
                  hapticFeedback: true,
                  selectTextStyle: const TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.w500),
                  selectItemDecoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.primary),
                ))));
  }
}
