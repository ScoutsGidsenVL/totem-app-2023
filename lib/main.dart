import 'package:flutter/material.dart';
import 'package:totemapp/model/checklist_data.dart';
import 'package:totemapp/model/dynamic_data.dart';
import 'package:totemapp/model/profile_manager.dart';
import 'package:totemapp/model/traits_filter.dart';
import 'package:totemapp/pages/checklist.dart';
import 'package:totemapp/pages/eigenschappen.dart';
import 'package:provider/provider.dart';
import 'package:totemapp/pages/filtered_totems.dart';
import 'package:totemapp/pages/profielen.dart';
import 'package:totemapp/pages/totems.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  Future.delayed(const Duration(milliseconds: 600)).then((_) {
    FlutterNativeSplash.remove();
  });
  runApp(const MyApp());
}

const primary = Color(0xFF005C9D);
const lightGray = Color(0xFF6C757D);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => DynamicData()),
          ChangeNotifierProvider(create: (_) => ChecklistData()),
          ChangeNotifierProxyProvider<DynamicData, ProfileManager>(
              update: (_, dynamicData, prev) =>
                  ProfileManager(dynamicData, prev?.selectedName),
              create: (_) => ProfileManager(null, null)),
          ChangeNotifierProxyProvider<ProfileManager, TraitsFilter>(
              update: (_, profileManager, prev) =>
                  TraitsFilter(profileManager, prev?.fallbackTraits),
              create: (_) => TraitsFilter(null, {})),
        ],
        child: MaterialApp(
            title: 'Totemapp',
            theme: ThemeData(
                colorScheme: const ColorScheme.light(
                    primary: primary,
                    primaryContainer: Color(0xFF004474),
                    secondary: Color(0xFF006CBA),
                    surfaceVariant: Color(0xFFE4E4E4),
                    onSurfaceVariant: lightGray),
                textTheme: const TextTheme(
                    headlineMedium: TextStyle(
                        fontSize: 34, color: primary, fontFamily: 'Verveine'),
                    headlineSmall: TextStyle(
                        fontSize: 17,
                        color: primary,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w300),
                    bodyLarge: TextStyle(fontSize: 21),
                    bodyMedium: TextStyle(fontSize: 21),
                    bodySmall: TextStyle(fontSize: 19, color: lightGray))),
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
      }
      return null;
    }),
    TabItem(1, 'Eigenschappen', Icons.psychology, (settings) {
      switch (settings.name) {
        case '/':
          return const Eigenschappen();
        case '/results':
          return const FilteredTotems();
      }
      return null;
    }),
    TabItem(2, 'Profielen', Icons.person, (settings) {
      return const Profielen();
    }, badge: (context) {
      final profile = context.watch<ProfileManager>().profile;
      if (profile == null) return null;
      return BadgeInfo(profile.name, profile.color.shade700);
    }),
    TabItem(3, 'Checklist', Icons.check_circle, (settings) {
      return const Checklist();
    }),
  ];

  int _currentIndex = 0;
  final _navigatorKeys = tabs.map((e) => GlobalKey<NavigatorState>()).toList();

  void _selectTab(int index) {
    if (_currentIndex == index) {
      _navigatorKeys[_currentIndex].currentState!.popUntil((r) => r.isFirst);
    } else {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          var popped =
              await _navigatorKeys[_currentIndex].currentState!.maybePop();
          if (popped) return false;
          if (_currentIndex != 0) {
            _selectTab(0);
            return false;
          }
          return true;
        },
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
              items: tabs.map((t) {
                final badge = t.badge?.call(context);
                return BottomNavigationBarItem(
                    icon: badge == null
                        ? Icon(t.icon)
                        : Badge(
                            label: Text(badge.label),
                            backgroundColor: badge.color ??
                                Theme.of(context).colorScheme.primary,
                            child: Icon(t.icon),
                          ),
                    label: t.title);
              }).toList(),
              currentIndex: _currentIndex,
              onTap: _selectTab,
              selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
            )));
  }
}

class TabItem {
  const TabItem(this.index, this.title, this.icon, this.router, {this.badge});
  final int index;
  final String title;
  final IconData icon;
  final Widget? Function(RouteSettings settings) router;
  final BadgeInfo? Function(BuildContext context)? badge;
}

class BadgeInfo {
  const BadgeInfo(this.label, this.color);
  final String label;
  final Color? color;
}
