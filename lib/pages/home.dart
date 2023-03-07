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
            FilledButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/totems');
                },
                child: const Text('Totems'))
          ],
        ));
  }
}
