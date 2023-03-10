import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:totem_app/model/dynamic_data.dart';
import 'package:totem_app/util.dart';

class Checklist extends StatelessWidget {
  const Checklist({super.key});

  @override
  Widget build(BuildContext context) {
    var body = context.watch<DynamicData>().text['checklist'] ?? '';
    return Scaffold(
        appBar: AppBar(title: const Text('Totemisatie checklist')),
        body: Markdown(data: body, styleSheet: markdownStyle(context)));
  }
}
