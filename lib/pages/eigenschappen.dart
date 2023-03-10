import 'package:azlistview/azlistview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:totem_app/model/dynamic_data.dart';
import 'package:totem_app/model/traits_filter.dart';
import 'package:totem_app/pages/totems.dart';

class Eigenschappen extends StatefulWidget {
  const Eigenschappen({Key? key}) : super(key: key);

  @override
  State<Eigenschappen> createState() => _EigenschappenState();
}

extension ISuspensionBean on String {
  String getSuspensionTag() {
    var tag = substring(0, 1).toUpperCase();
    if (RegExp("[A-Z]").hasMatch(tag)) {
      return tag;
    } else {
      return "#";
    }
  }
}

class _EigenschappenState extends State<Eigenschappen> {
  @override
  Widget build(BuildContext context) {
    var traits = context.watch<DynamicData>().traits?.values.toList() ?? [];
    var filter = context.watch<TraitsFilter>();

    return Scaffold(
        body: Scrollbar(
            child: AzListView(
                data: traits,
                itemCount: traits.length,
                itemBuilder: (context, index) {
                  var trait = traits[index];
                  return CheckboxListTile(
                    contentPadding: const EdgeInsets.only(left: 16, right: 32),
                    value: filter.isSelected(trait.name),
                    onChanged: (enabled) =>
                        {filter.selectTrait(trait.name, enabled ?? false)},
                    title: Text(trait.name),
                    activeColor: Theme.of(context).colorScheme.primary,
                  );
                },
                indexBarData: SuspensionUtil.getTagIndexList(traits),
                indexBarOptions: IndexBarOptions(
                  needRebuild: true,
                  hapticFeedback: true,
                  selectTextStyle: const TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.w500),
                  selectItemDecoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.primary),
                ))),
        bottomSheet: filter.isEmpty
            ? null
            : Material(
                color: Theme.of(context).colorScheme.primary,
                child: Row(children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 12),
                      child: Text('${filter.length} geselecteerd',
                          style: const TextStyle(color: Colors.white)),
                    ),
                  ),
                  FilledButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/results',
                          arguments: TotemsArguments(filtered: true));
                    },
                    child: Row(
                      children: const [
                        Text('VIND TOTEMS',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w300)),
                        Icon(Icons.arrow_forward, color: Colors.white)
                      ],
                    ),
                  )
                ]),
              ));
  }
}
