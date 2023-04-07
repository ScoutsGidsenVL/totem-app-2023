import 'package:collection/collection.dart';
import 'package:azlistview/azlistview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:totemapp/model/dynamic_data.dart';
import 'package:totemapp/model/profile_manager.dart';
import 'package:totemapp/model/traits_filter.dart';
import 'package:totemapp/util.dart';
import 'package:totemapp/widgets/profile_dialog.dart';
import 'package:totemapp/widgets/trait_entry.dart';

class Eigenschappen extends StatefulWidget {
  const Eigenschappen({Key? key}) : super(key: key);

  @override
  State<Eigenschappen> createState() => _EigenschappenState();
}

class _EigenschappenState extends State<Eigenschappen>
    with WidgetsBindingObserver {
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
    final filter = context.watch<TraitsFilter>();
    final allTraits =
        context.watch<DynamicData>().traits?.values.toList() ?? [];
    final profileManager = context.watch<ProfileManager>();

    final searchTraits = _search.isEmpty
        ? allTraits
        : allTraits
            .map((t) {
              var score = 0;
              if (t.name.toLowerCase().contains(_search)) score += 10;
              if (t.name.toLowerCase().startsWith(_search)) score += 20;
              for (var s in t.synonyms) {
                if (s.toLowerCase().contains(_search)) score += 1;
                if (s.toLowerCase().startsWith(_search)) score += 2;
              }
              return MapEntry(t, score);
            })
            .where((e) => e.value > 0)
            .sorted((a, b) => b.value - a.value)
            .map((e) => e.key)
            .toList();

    var traits = _showRelevant && filter.length > 0
        ? searchTraits
            .where((t) => filter.getState(t.name) != TraitState.neutral)
            .toList()
        : searchTraits;

    if (filter.isEmpty && _showRelevant) {
      Future.microtask(() => setState(() => _showRelevant = false));
    }

    if (profileManager.showRelevantTraits) {
      profileManager.showRelevantTraits = false;
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
                                filter.isEmpty
                                    ? Container()
                                    : IconButton(
                                        onPressed: toggleRelevant,
                                        icon: Icon(_showRelevant
                                            ? Icons.check_box
                                            : Icons.check_box_outline_blank)),
                              ]),
                          labelText: 'Zoek eigenschap',
                          border: const OutlineInputBorder()))),
              Expanded(
                  child: Scrollbar(
                      child: LayoutBuilder(
                          builder: (context, constraints) => AzListView(
                              data: traits,
                              itemCount: traits.length,
                              itemBuilder: (context, index) {
                                var trait = traits[index];
                                return TraitEntry(trait: trait);
                              },
                              indexBarData: _search.isNotEmpty ||
                                      constraints.maxHeight < 400
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
                                    color:
                                        Theme.of(context).colorScheme.primary),
                              ))))),
              filter.isEmpty
                  ? Container()
                  : Material(
                      color: Theme.of(context).colorScheme.primary,
                      child: Row(children: [
                        IconButton(
                            onPressed: () {
                              final oldTraits =
                                  Map<String, TraitState>.from(filter.traits);
                              filter.reset();
                              showUndo(context, 'Selectie gewist', () {
                                context
                                    .read<TraitsFilter>()
                                    .updateTraits(oldTraits, clear: true);
                              });
                            },
                            icon: Icon(Icons.delete,
                                color:
                                    Theme.of(context).colorScheme.onPrimary)),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 16, horizontal: 12),
                            child: Text('${filter.selectedCount} geselecteerd',
                                style: const TextStyle(color: Colors.white)),
                          ),
                        ),
                        FilledButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/results');
                            },
                            child: Row(
                              children: [
                                Text('VIND TOTEMS',
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary,
                                        fontWeight: FontWeight.w300)),
                                Icon(Icons.arrow_forward,
                                    color:
                                        Theme.of(context).colorScheme.onPrimary)
                              ],
                            ))
                      ]))
            ]),
            floatingActionButton: profileManager.profile != null ||
                    filter.isEmpty
                ? null
                : Padding(
                    padding: const EdgeInsets.only(bottom: 57),
                    child: FloatingActionButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return ProfileDialog(
                                    onSubmitted: (name, color) {
                                  final profileTraits =
                                      Map<String, TraitState>.from(
                                          filter.traits);
                                  filter.reset();
                                  context.read<ProfileManager>().createProfile(
                                      name,
                                      traits: profileTraits,
                                      color: color);
                                });
                              });
                        },
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor:
                            Theme.of(context).colorScheme.onPrimary,
                        child: const Icon(Icons.person_add)),
                  )));
  }
}
