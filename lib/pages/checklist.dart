import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:totem_app/model/dynamic_data.dart';

class Checklist extends StatelessWidget {
  const Checklist({super.key});

  @override
  Widget build(BuildContext context) {
    var body = context.watch<DynamicData>().text['checklist'] ?? '';
    return Scaffold(
        appBar: AppBar(title: const Text('Checklist')),
        body: Markdown(data: body, styleSheet: markdownStyle(context)));
  }
}

MarkdownStyleSheet markdownStyle(BuildContext context) {
  return MarkdownStyleSheet(
      p: const TextStyle(fontSize: 18),
      a: TextStyle(
          color: Theme.of(context).colorScheme.secondary,
          decoration: TextDecoration.underline),
      h2: TextStyle(
          fontSize: 24, color: Theme.of(context).colorScheme.secondary),
      h2Padding: const EdgeInsets.only(top: 8));
}
