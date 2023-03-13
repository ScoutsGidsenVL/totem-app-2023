import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:totem_app/model/dynamic_data.dart';
import 'package:azlistview/azlistview.dart';
import 'package:totem_app/widgets/animal_entry.dart';

class Totems extends StatefulWidget {
  const Totems({Key? key}) : super(key: key);

  @override
  State<Totems> createState() => _TotemsState();
}

class _TotemsState extends State<Totems> {
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
    var allAnimals =
        context.watch<DynamicData>().animals?.values.toList() ?? [];
    var animals = _search.isEmpty
        ? allAnimals
        : allAnimals
            .map((a) {
              var score = 0;
              if (a.name.toLowerCase().contains(_search)) score += 3;
              if (a.name.toLowerCase().startsWith(_search)) score += 6;
              a.synonyms?.forEach((s) {
                if (s.toLowerCase().contains(_search)) score += 1;
                if (s.toLowerCase().startsWith(_search)) score += 2;
              });
              return MapEntry(a, score);
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
                      labelText: 'Zoek totem',
                      border: const OutlineInputBorder()))),
          Expanded(
              child: LayoutBuilder(
                  builder: (context, constraints) => AzListView(
                      data: animals,
                      itemCount: animals.length,
                      itemBuilder: (context, index) {
                        return AnimalEntry(animal: animals[index]);
                      },
                      indexBarData:
                          _search.isNotEmpty || constraints.maxHeight < 400
                              ? []
                              : SuspensionUtil.getTagIndexList(animals),
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
        ]))));
  }
}
