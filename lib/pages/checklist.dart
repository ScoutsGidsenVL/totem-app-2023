import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:totemapp/model/checklist_data.dart';
import 'package:totemapp/model/dynamic_data.dart';
import 'package:totemapp/util.dart';

class Checklist extends StatelessWidget {
  const Checklist({super.key});

  @override
  Widget build(BuildContext context) {
    final body = context.watch<DynamicData>().text['checklist'] ?? '';
    final checklist = context.watch<ChecklistData>();

    final parts = <String>[];
    var currentPart = '';
    for (final line in body.split('\n')) {
      if (line.trimLeft().startsWith('- ')) {
        if (currentPart.isNotEmpty) {
          parts.add(currentPart.trim());
          currentPart = '';
        }
        parts.add(line);
      } else {
        currentPart += '$line\n';
      }
    }
    if (currentPart.isNotEmpty) {
      parts.add(currentPart.trim());
    }

    return Scaffold(
        body: ListView(
      padding: const EdgeInsets.only(top: 8),
      children: [
        ...parts.map((p) {
          if (!p.trim().startsWith('- ')) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: MarkdownBody(data: p, styleSheet: markdownStyle(context)),
            );
          }
          final name = p.trim().substring(2);
          return CheckboxListTile(
              contentPadding:
                  EdgeInsets.only(left: p.startsWith(' ') ? 40 : 16, right: 16),
              controlAffinity: ListTileControlAffinity.leading,
              visualDensity: VisualDensity.compact,
              dense: true,
              activeColor: Theme.of(context).colorScheme.primary,
              value: checklist.isChecked(name),
              onChanged: (enabled) {
                checklist.toggleCheck(name);
              },
              title: Text(name, style: const TextStyle(fontSize: 18)));
        }),
        TextButton(
            onPressed: () {
              final oldChecked = List<String>.from(checklist.checked);
              checklist.reset();
              showUndo(context, 'Checklist gewist', () {
                context.read<ChecklistData>().set(oldChecked);
              });
            },
            style: const ButtonStyle(
                padding: MaterialStatePropertyAll(EdgeInsets.all(24))),
            child: const Text('Checklist wissen'))
      ],
    ));
  }
}
