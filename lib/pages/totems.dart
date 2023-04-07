import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:totemapp/model/dynamic_data.dart';
import 'package:azlistview/azlistview.dart';
import 'package:totemapp/model/profile_manager.dart';
import 'package:totemapp/widgets/animal_entry.dart';

class Totems extends StatefulWidget {
  const Totems({Key? key}) : super(key: key);

  @override
  State<Totems> createState() => _TotemsState();
}

class _TotemsState extends State<Totems> with WidgetsBindingObserver {
  final FocusNode _searchFocus = FocusNode();
  final TextEditingController _searchController = TextEditingController();
  String _search = '';
  bool _showRelevant = false;
  bool _isKeyboardVisible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeMetrics() {
    final bottomInset = WidgetsBinding.instance.window.viewInsets.bottom;
    final newValue = bottomInset > 0.0;
    if (newValue != _isKeyboardVisible) {
      setState(() {
        _isKeyboardVisible = newValue;
        if (!_isKeyboardVisible) {
          _searchFocus.unfocus();
        }
      });
    }
  }

  void doSearch(String query) {
    setState(() {
      _search = query.toLowerCase();
    });
  }

  void clearSearch() {
    setState(() {
      _searchFocus.unfocus();
      _searchController.clear();
      _search = '';
    });
  }

  void toggleRelevant() {
    setState(() {
      _showRelevant = !_showRelevant;
    });
  }

  @override
  void dispose() {
    _searchFocus.dispose();
    _searchController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final allAnimals =
        context.watch<DynamicData>().animals?.values.toList() ?? [];
    final profileManager = context.watch<ProfileManager>();
    final profiles = profileManager.profiles;
    final profile = profileManager.profile;

    var searchAnimals = _search.isEmpty
        ? allAnimals
        : allAnimals
            .map((a) {
              var score = 0;
              if (a.name.toLowerCase().contains(_search)) score += 3;
              if (a.name.toLowerCase().startsWith(_search)) score += 6;
              for (var s in a.synonyms) {
                if (s.toLowerCase().contains(_search)) score += 1;
                if (s.toLowerCase().startsWith(_search)) score += 2;
              }
              return MapEntry(a, score);
            })
            .where((e) => e.value > 0)
            .sorted((a, b) => b.value - a.value)
            .map((e) => e.key)
            .toList();

    var relevantAnimals = searchAnimals.where((a) {
      return profile == null
          ? profiles.any((p) => p.animals.contains(a.name))
          : profile.animals.contains(a.name);
    }).toList();

    var animals = _showRelevant ? relevantAnimals : searchAnimals;

    if (relevantAnimals.isEmpty && _showRelevant) {
      Future.microtask(() => setState(() => _showRelevant = false));
    }

    if (profileManager.showRelevantAnimals) {
      profileManager.showRelevantAnimals = false;
      Future.microtask(() => setState(() => _showRelevant = true));
    }

    return WillPopScope(
        onWillPop: () async {
          if (_search.isNotEmpty || _showRelevant) {
            clearSearch();
            setState(() => _showRelevant = false);
            return false;
          }
          return true;
        },
        child: Scaffold(
            body: Column(children: [
          Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                  focusNode: _searchFocus,
                  controller: _searchController,
                  onChanged: doSearch,
                  decoration: InputDecoration(
                      suffixIcon: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _search.isEmpty
                                ? Container()
                                : IconButton(
                                    onPressed: clearSearch,
                                    icon: const Icon(Icons.close)),
                            relevantAnimals.isEmpty
                                ? Container()
                                : IconButton(
                                    onPressed: toggleRelevant,
                                    icon: Icon(_showRelevant
                                        ? Icons.star
                                        : Icons.star_outline))
                          ]),
                      labelText: 'Zoek totem',
                      border: const OutlineInputBorder()))),
          Expanded(
            child: Scrollbar(
                child: LayoutBuilder(
                    builder: (context, constraints) => AzListView(
                        data: animals,
                        itemCount: animals.length,
                        itemBuilder: (context, index) {
                          return AnimalEntry(
                              animal: animals[index],
                              padRight: true,
                              swipeList: animals);
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
          )
        ])));
  }
}
