import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Totemapp'),
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: FilledButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/totems');
                    },
                    child: const Text('Totems'))),
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: FilledButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/eigenschappen');
                    },
                    child: const Text('Eigenschappen'))),
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: FilledButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/profielen');
                    },
                    child: const Text('Profielen'))),
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: FilledButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/checklist');
                    },
                    child: const Text('Totemisatie Checklist'))),
          ],
        ));
  }
}
