import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:totem_app/model/dynamic_data.dart';
import 'package:totem_app/pages/totem_detail.dart';

class Totems extends StatelessWidget {
  const Totems({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var animals = context.watch<DynamicData>().animals?.values.toList() ?? [];

    return Scaffold(
        appBar: AppBar(
          title: const Text('Totems'),
        ),
        body: Scrollbar(
            child: ListView.builder(
                itemCount: animals.length,
                itemBuilder: (context, index) {
                  var animal = animals[index];
                  return ListTile(
                    onTap: () {
                      Navigator.pushNamed(context, '/totem',
                          arguments: TotemDetailArguments(animal.name));
                    },
                    title: Text(animal.name),
                  );
                })));
  }
}
