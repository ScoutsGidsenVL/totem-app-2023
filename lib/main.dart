import 'package:flutter/material.dart';
import 'package:totem_app/model/dynamic_data.dart';
import 'package:totem_app/model/loaded_profile.dart';
import 'package:totem_app/model/traits_filter.dart';
import 'package:totem_app/pages/checklist.dart';
import 'package:totem_app/pages/eigenschappen.dart';
import 'package:provider/provider.dart';
import 'package:totem_app/pages/filtered_totems.dart';
import 'package:totem_app/pages/profielen.dart';
import 'package:totem_app/pages/totem_detail.dart';
import 'package:totem_app/pages/totems.dart';

void main() {
  runApp(const MyApp());
}

const primary = Color(0xFF005C9D);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => DynamicData()),
          ChangeNotifierProvider(create: (_) => TraitsFilter()),
          ChangeNotifierProvider(create: (_) => LoadedProfile()),
        ],
        child: MaterialApp(
            title: 'Totemapp',
            theme: ThemeData(
                colorScheme: const ColorScheme.light(
                    primary: primary,
                    primaryContainer: Color(0xFF004474),
                    secondary: Color.fromARGB(255, 0, 108, 186)),
                textTheme: const TextTheme(
                    headlineMedium: TextStyle(
                        fontSize: 34, color: primary, fontFamily: 'Verveine'),
                    headlineSmall: TextStyle(
                        fontSize: 17,
                        color: primary,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w300),
                    bodyMedium:
                        TextStyle(fontSize: 21, fontWeight: FontWeight.w300))),
            home: const Home()));
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin<Home> {
  static List<TabItem> tabs = [
    TabItem(0, 'Totems', Icons.pets, (settings) {
      switch (settings.name) {
        case '/':
          return const Totems();
        case '/totem-detail':
          final args = settings.arguments as TotemDetailArguments;
          return TotemDetail(name: args.name);
      }
      return null;
    }),
    TabItem(1, 'Eigenschappen', Icons.question_answer, (settings) {
      switch (settings.name) {
        case '/':
          return const Eigenschappen();
        case '/results':
          return const FilteredTotems();
        case '/totem-detail':
          final args = settings.arguments as TotemDetailArguments;
          return TotemDetail(name: args.name);
      }
      return null;
    }),
    TabItem(2, 'Profielen', Icons.person, (settings) {
      return const Profielen();
    }),
    TabItem(3, 'Checklist', Icons.check_circle, (settings) {
      return const Checklist();
    }),
  ];

  int _currentIndex = 0;
  final _navigatorKeys = tabs.map((e) => GlobalKey<NavigatorState>()).toList();

  void _selectTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async =>
            !await _navigatorKeys[_currentIndex].currentState!.maybePop(),
        child: Scaffold(
            body: Stack(
                children: tabs
                    .map((t) => Offstage(
                        offstage: _currentIndex != t.index,
                        child: SafeArea(
                            child: Navigator(
                                key: _navigatorKeys[t.index],
                                onGenerateRoute: (settings) {
                                  return MaterialPageRoute(builder: (context) {
                                    var res = t.router(settings);
                                    if (res == null) {
                                      assert(false);
                                      return const SizedBox();
                                    }
                                    return res;
                                  });
                                }))))
                    .toList()),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              items: tabs
                  .map((t) => BottomNavigationBarItem(
                      icon: Icon(t.icon), label: t.title))
                  .toList(),
              currentIndex: _currentIndex,
              onTap: _selectTab,
            )));
  }
}

class TabItem {
  const TabItem(this.index, this.title, this.icon, this.router);
  final int index;
  final String title;
  final IconData icon;
  final Widget? Function(RouteSettings) router;
}
