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
import 'package:beamer/beamer.dart';

final List<TabInfo> tabs = [
  TabInfo(
    title: 'Totems',
    icon: Icons.pets,
    path: '/totems',
    locationBuilder: (info, params) {
      return TotemsLocation(info);
    },
  ),
  TabInfo(
    title: 'Eigenschappen',
    icon: Icons.psychology,
    path: '/eigenschappen',
    locationBuilder: (info, params) {
      return EigenschappenLocation(info);
    },
  ),
  TabInfo(
    title: 'Profielen',
    icon: Icons.person,
    path: '/profielen',
    locationBuilder: (info, params) {
      return ProfielenLocation(info);
    },
    badge: (context) {
      final profile = context.watch<ProfileManager>().profile;
      if (profile == null) return null;
      final darkMode =
          MediaQuery.of(context).platformBrightness == Brightness.dark;
      return BadgeInfo(profile.name, profile.color[darkMode ? 400 : 700]);
    },
  ),
  TabInfo(
    title: 'Checklist',
    icon: Icons.check_circle,
    path: '/checklist',
    locationBuilder: (info, params) {
      return ChecklistLocation(info);
    },
  ),
];

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  Future.delayed(const Duration(milliseconds: 600)).then((_) {
    FlutterNativeSplash.remove();
  });
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final routerDelegate = BeamerDelegate(
      initialPath: '/totems',
      locationBuilder: RoutesLocationBuilder(routes: {
        '*': (context, state, data) => const ScaffoldWithNavBar(),
      }));

  @override
  Widget build(BuildContext context) {
    const primaryLight = Color(0xFF005C9D);
    const primaryDark = Color(0xFF4FA6E4);

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
        child: MaterialApp.router(
          title: 'Totemapp',
          theme: ThemeData(
              colorScheme: const ColorScheme.light(
                  primary: primaryLight,
                  secondary: primaryLight,
                  surfaceVariant: Color(0xFFE4E4E4),
                  onSurfaceVariant: Color(0xFF6C757D)),
              textTheme: const TextTheme(
                  headlineMedium: TextStyle(
                      fontSize: 34,
                      color: primaryLight,
                      fontFamily: 'Verveine'),
                  headlineSmall: TextStyle(
                      fontSize: 17,
                      color: primaryLight,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w300),
                  bodyLarge: TextStyle(fontSize: 21),
                  bodyMedium: TextStyle(fontSize: 21),
                  bodySmall:
                      TextStyle(fontSize: 19, color: Color(0xFF6C757D)))),
          darkTheme: ThemeData(
              colorScheme: const ColorScheme.dark(
                  primary: primaryDark,
                  secondary: primaryDark,
                  surfaceVariant: Color(0xFF272727),
                  onSurfaceVariant: Color(0xFFA8B1B9)),
              textTheme: const TextTheme(
                  headlineMedium: TextStyle(
                      fontSize: 34, color: primaryDark, fontFamily: 'Verveine'),
                  headlineSmall: TextStyle(
                      fontSize: 17,
                      color: primaryDark,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w300),
                  bodyLarge: TextStyle(fontSize: 21),
                  bodyMedium: TextStyle(fontSize: 21),
                  bodySmall:
                      TextStyle(fontSize: 19, color: Color(0xFFA8B1B9)))),
          routerDelegate: routerDelegate,
          routeInformationParser: BeamerParser(),
          backButtonDispatcher:
              BeamerBackButtonDispatcher(delegate: routerDelegate),
        ));
  }
}

class ScaffoldWithNavBar extends StatefulWidget {
  const ScaffoldWithNavBar({super.key});

  @override
  State<ScaffoldWithNavBar> createState() => _ScaffoldWithNavBarState();
}

class _ScaffoldWithNavBarState extends State<ScaffoldWithNavBar> {
  late int _currentIndex;

  final _routerDelegates = tabs
      .map((t) => BeamerDelegate(
          initialPath: t.path,
          locationBuilder: (info, params) {
            if (info.location!.contains(t.path)) {
              return t.locationBuilder(info, params);
            }
            return NotFound(path: info.location!);
          }))
      .toList();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final location = Beamer.of(context).configuration.location!;
    final index = tabs.lastIndexWhere((tab) => location.startsWith(tab.path));
    _currentIndex = index < 0 ? 0 : index;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        var popped = await _routerDelegates[_currentIndex].popRoute();
        if (popped) return false;
        if (_currentIndex != 0) {
          setState(() => _currentIndex = 0);
          _routerDelegates[_currentIndex].update(rebuild: false);
          return false;
        }
        return true;
      },
      child: Scaffold(
        body: SafeArea(
          child: IndexedStack(
            index: _currentIndex,
            children: _routerDelegates
                .map((delegate) => Beamer(routerDelegate: delegate))
                .toList(),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: tabs.map((t) {
            final badge = t.badge?.call(context);
            return BottomNavigationBarItem(
                icon: badge == null
                    ? Icon(t.icon)
                    : Badge(
                        label: ConstrainedBox(
                            constraints: const BoxConstraints(
                              maxWidth: 80,
                            ),
                            child: Text(badge.label,
                                overflow: TextOverflow.fade,
                                maxLines: 1,
                                softWrap: false)),
                        backgroundColor: badge.color ??
                            Theme.of(context).colorScheme.primary,
                        child: Icon(t.icon),
                      ),
                label: t.title);
          }).toList(),
          currentIndex: _currentIndex,
          onTap: (index) {
            if (index != _currentIndex) {
              setState(() => _currentIndex = index);
              _routerDelegates[_currentIndex].update(rebuild: false);
            } else {
              _routerDelegates[_currentIndex]
                  .popToNamed(tabs[_currentIndex].path);
            }
          },
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class TabInfo {
  const TabInfo({
    required this.title,
    required this.icon,
    required this.path,
    required this.locationBuilder,
    this.badge,
  });

  final String title;
  final IconData icon;
  final String path;
  final BeamLocation<RouteInformationSerializable<dynamic>> Function(
      RouteInformation info, BeamParameters? params) locationBuilder;
  final BadgeInfo? Function(BuildContext context)? badge;
}

class BadgeInfo {
  const BadgeInfo(this.label, this.color);
  final String label;
  final Color? color;
}

class TotemsLocation extends BeamLocation<BeamState> {
  TotemsLocation(super.info);
  @override
  List<String> get pathPatterns => ['/totems'];
  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) => [
        const BeamPage(
          key: ValueKey('totems'),
          child: Totems(),
        ),
      ];
}

class EigenschappenLocation extends BeamLocation<BeamState> {
  EigenschappenLocation(super.info);
  @override
  List<String> get pathPatterns => ['/eigenschappen/*'];
  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) => [
        const BeamPage(
          key: ValueKey('eigenschappen'),
          child: Eigenschappen(),
        ),
        if (state.uri.pathSegments.length == 2)
          const BeamPage(
            key: ValueKey('eigenschappen/results'),
            child: FilteredTotems(),
          ),
      ];
}

class ProfielenLocation extends BeamLocation<BeamState> {
  ProfielenLocation(super.info);
  @override
  List<String> get pathPatterns => ['/profielen'];
  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) => [
        const BeamPage(
          key: ValueKey('profielen'),
          child: Profielen(),
        ),
      ];
}

class ChecklistLocation extends BeamLocation<BeamState> {
  ChecklistLocation(super.info);
  @override
  List<String> get pathPatterns => ['/checklist'];
  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) => [
        const BeamPage(
          key: ValueKey('checklist'),
          child: Checklist(),
        ),
      ];
}
