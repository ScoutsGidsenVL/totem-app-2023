import 'package:flutter/material.dart';
import 'package:totemapp/model/totem_data.dart';
import 'package:totemapp/widgets/animal_name.dart';
import 'package:totemapp/widgets/traits_list.dart';

class AnimalPreviewCard extends StatelessWidget {
  const AnimalPreviewCard({super.key, required this.animal, this.onPressed});

  final AnimalData animal;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: InkWell(
        onTap: onPressed,
        child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: AnimalName(animal)),
                TraitsList(animal.traits),
              ],
            )),
      ),
    );
  }
}
