import 'package:collection/collection.dart';
import 'package:azlistview/azlistview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:totem_app/model/dynamic_data.dart';
import 'package:totem_app/model/traits_filter.dart';

class Eigenschappen extends StatefulWidget {
  const Eigenschappen({Key? key}) : super(key: key);

  @override
  State<Eigenschappen> createState() => _EigenschappenState();
}

class _EigenschappenState extends State<Eigenschappen> {
  final TextEditingController _searchController = TextEditingController();
  String _search = '';

  void doSearch(String query) {
    setState(() {
      _search = query.toLowerCase();
    });
  }

  void clearSearch() {
    setState(() {
      _searchController.clear();
      _search = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    var filter = context.watch<TraitsFilter>();
    var allTraits = context.watch<DynamicData>().traits?.values.toList() ?? [];
    var traits = _search.isEmpty
        ? allTraits
        : allTraits
            .map((t) {
              var score = 0;
              if (t.name.toLowerCase().contains(_search)) score += 3;
              if (t.name.toLowerCase().startsWith(_search)) score += 6;
              return MapEntry(t, score);
            })
            .where((e) => e.value > 0)
            .sorted((a, b) => b.value - a.value)
            .map((e) => e.key)
            .toList();

    return WillPopScope(
        onWillPop: () async {
          if (_search.isNotEmpty) {
            clearSearch();
            return false;
          }
          return true;
        },
        child: Scaffold(
            body: Scrollbar(
                child: Column(children: [
              Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                      controller: _searchController,
                      onChanged: doSearch,
                      decoration: InputDecoration(
                          suffixIcon: _search.isEmpty
                              ? null
                              : IconButton(
                                  onPressed: clearSearch,
                                  icon: const Icon(Icons.close)),
                          labelText: 'Zoek eigenschap',
                          border: const OutlineInputBorder()))),
              Expanded(
                  child: LayoutBuilder(
                      builder: (context, constraints) => AzListView(
                          data: traits,
                          itemCount: traits.length,
                          itemBuilder: (context, index) {
                            var trait = traits[index];
                            return CheckboxListTile(
                              contentPadding:
                                  const EdgeInsets.only(left: 16, right: 32),
                              value: filter.isSelected(trait.name),
                              onChanged: (enabled) => {
                                filter.selectTrait(trait.name, enabled ?? false)
                              },
                              title: Text(trait.name),
                              activeColor:
                                  Theme.of(context).colorScheme.primary,
                            );
                          },
                          indexBarData:
                              _search.isNotEmpty || constraints.maxHeight < 400
                                  ? []
                                  : SuspensionUtil.getTagIndexList(traits),
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
                          )))),
            ])),
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
                          Navigator.pushNamed(context, '/results');
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
                  )));
  }
}
