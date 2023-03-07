import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:totem_app/model/dynamic_data.dart';

class Totems extends StatelessWidget {
  const Totems({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var animals = context.watch<DynamicData>().animals ?? [];

    return Scaffold(
        appBar: AppBar(
          title: const Text('Totems'),
        ),
        body: ListView.builder(
            itemCount: animals.length,
            itemBuilder: (context, index) {
              var animal = animals[index];
              return ListTile(
                title: Text(animal.name),
                subtitle: animal.synonyms == null
                    ? null
                    : Text(animal.synonyms!.take(4).join(', ')),
              );
            }));
  }
}
