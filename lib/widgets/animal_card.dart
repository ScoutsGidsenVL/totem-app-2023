import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:totem_app/model/profile_manager.dart';
import 'package:totem_app/model/totem_data.dart';
import 'package:totem_app/widgets/animal_star_button.dart';

class AnimalCard extends StatelessWidget {
  final AnimalData animal;

  const AnimalCard({super.key, required this.animal});

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<ProfileManager>().profile;

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${animal.id.toString()}. ',
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(color: Theme.of(context).colorScheme.tertiary)),
          Expanded(
              child: Text.rich(
                  TextSpan(children: [
                    TextSpan(
                        text: animal.name,
                        style: Theme.of(context).textTheme.headlineMedium),
                    TextSpan(
                        text: animal.synonyms.isEmpty
                            ? null
                            : ' - ${animal.synonyms.join(', ')}',
                        style: Theme.of(context).textTheme.headlineSmall),
                  ]),
                  softWrap: true)),
          profile == null ? Container() : AnimalStarButton(animal: animal.name),
        ],
      ),
      const Padding(
        padding: EdgeInsets.only(top: 8, bottom: 12),
        child: Image(image: AssetImage('assets/images/separation.png')),
      ),
      Text(animal.description, style: Theme.of(context).textTheme.bodyMedium),
    ]);
  }
}
