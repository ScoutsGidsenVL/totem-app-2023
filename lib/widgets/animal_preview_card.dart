import 'package:flutter/material.dart';
import 'package:totem_app/model/totem_data.dart';

class AnimalPreviewCard extends StatelessWidget {
  const AnimalPreviewCard({super.key, required this.animal, this.onPressed});

  final AnimalData animal;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: onPressed,
        child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text.rich(TextSpan(
                      children: [
                        TextSpan(
                            text: '${animal.id.toString()}. ',
                            style: const TextStyle(fontSize: 18)),
                        TextSpan(text: animal.name),
                      ],
                    ))),
                Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Padding(
                      padding: EdgeInsets.only(right: 8),
                      child: Icon(Icons.psychology)),
                  Flexible(
                      child: Text(animal.traits.join(', '),
                          style: const TextStyle(
                              fontSize: 18, fontStyle: FontStyle.italic),
                          softWrap: true))
                ])
              ],
            )),
      ),
    );
  }
}
