import 'package:flutter/material.dart';
import 'package:totemapp/model/settings_data.dart';
import 'package:totemapp/model/dynamic_data.dart';
import 'package:totemapp/model/profile_manager.dart';
import 'package:totemapp/model/traits_filter.dart';
import 'package:totemapp/pages/totemisatie.dart';
import 'package:totemapp/pages/instellingen.dart';
import 'package:totemapp/pages/eigenschappen.dart';
import 'package:provider/provider.dart';
import 'package:totemapp/pages/filtered_totems.dart';
import 'package:totemapp/pages/import_profile.dart';
import 'package:totemapp/pages/profielen.dart';
import 'package:totemapp/pages/totems.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:beamer/beamer.dart';
import 'package:totemapp/pages/verborgen_totems.dart';

final List<TabInfo> tabs = [
  TabInfo(
    title: 'Totemisatie',
    icon: const Icon(Icons.home),
    path: '/totemisatie',
    locationBuilder: (info, params) {
      return TotemisatieLocation(info);
    },
  ),
  TabInfo(
    title: 'Totems',
    icon: const Icon(Icons.pets),
    path: '/totems',
    locationBuilder: (info, params) {
      return TotemsLocation(info);
    },
  ),
  TabInfo(
    title: 'Eigenschappen',
    icon: const Icon(Icons.psychology),
    path: '/eigenschappen',
    locationBuilder: (info, params) {
      return EigenschappenLocation(info);
    },
  ),
  TabInfo(
    title: 'Profielen',
    icon: Builder(builder: (context) {
      final profile = context.watch<ProfileManager>().profile;
      if (profile == null) return const Icon(Icons.person);
      return Badge(
          label: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 40,
              ),
              child: Text(profile.name,
                  overflow: TextOverflow.fade, maxLines: 1, softWrap: false)),
          backgroundColor: profile.getColor(context),
          child: const Icon(Icons.person));
    }),
    path: '/profielen',
    locationBuilder: (info, params) {
      return ProfielenLocation(info);
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
      initialPath: '/totemisatie',
      locationBuilder: RoutesLocationBuilder(routes: {
        '*': (context, state, data) => const ScaffoldWithNavBar(),
      }).call);

  @override
  Widget build(BuildContext context) {
    var colorSchemeLight = ColorScheme.fromSeed(seedColor: Color(0xFF005C9D));
    var colorSchemeDark = ColorScheme.fromSeed(
        seedColor: Color(0xFF4FA6E4), brightness: Brightness.dark);
    var textThemeLight = TextTheme(
        headlineMedium: TextStyle(
            fontSize: 34,
            fontFamily: 'Verveine',
            color: colorSchemeLight.primary),
        headlineSmall: TextStyle(
            fontSize: 17,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w300,
            color: colorSchemeLight.primary),
        bodyLarge: TextStyle(fontSize: 21),
        bodyMedium: TextStyle(fontSize: 21),
        bodySmall:
            TextStyle(fontSize: 19, color: colorSchemeLight.onSurfaceVariant));
    var textThemeDark = TextTheme(
        headlineMedium: TextStyle(
            fontSize: 34,
            fontFamily: 'Verveine',
            color: colorSchemeDark.primary),
        headlineSmall: TextStyle(
            fontSize: 17,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w300,
            color: colorSchemeDark.primary),
        bodyLarge: TextStyle(fontSize: 21),
        bodyMedium: TextStyle(fontSize: 21),
        bodySmall:
            TextStyle(fontSize: 19, color: colorSchemeDark.onSurfaceVariant));

    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => DynamicData()),
          ChangeNotifierProvider(create: (_) => SettingsData()),
          ChangeNotifierProxyProvider<DynamicData, ProfileManager>(
              update: (_, dynamicData, prev) =>
                  ProfileManager(dynamicData, prev?.selectedName),
              create: (_) => ProfileManager(null, null)),
          ChangeNotifierProxyProvider<ProfileManager, TraitsFilter>(
              update: (_, profileManager, prev) =>
                  TraitsFilter(profileManager, prev?.fallbackTraits),
              create: (_) => TraitsFilter(null, {})),
        ],
        child: Builder(builder: (context) {
          return MaterialApp.router(
            title: 'Totemapp',
            theme: ThemeData(
                colorScheme: colorSchemeLight, textTheme: textThemeLight),
            darkTheme: ThemeData(
                colorScheme: colorSchemeDark, textTheme: textThemeDark),
            themeMode: context.watch<SettingsData>().theme,
            routerDelegate: routerDelegate,
            routeInformationParser: BeamerParser(onParse: (info) {
              if (info.uri.path.contains('?p=')) {
                final code = info.uri.queryParameters['p'] ?? '';
                final query = Uri.encodeQueryComponent(
                    ProfileManager.importPrefix + code);
                return RouteInformation(
                    uri: Uri.parse('/profielen/import?code=$query'),
                    state: info.state);
              }
              return info;
            }),
            backButtonDispatcher: BeamerBackButtonDispatcher(
                delegate: routerDelegate, fallbackToBeamBack: false),
          );
        }));
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
            if (info.uri.path.contains(t.path)) {
              return t.locationBuilder(info, params);
            }
            return NotFound(path: info.uri.path);
          }))
      .toList();

  BeamerDelegate get currentDelegate => _routerDelegates[_currentIndex];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final uri = Beamer.of(context).configuration.uri;
    final index = tabs.lastIndexWhere((tab) => uri.path.startsWith(tab.path));
    _currentIndex = index < 0 ? 0 : index;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        var popped = await currentDelegate.popRoute();
        if (popped) return false;
        if (_currentIndex != 0) {
          setState(() => _currentIndex = 0);
          currentDelegate.update(rebuild: false);
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
        bottomNavigationBar: NavigationBar(
          destinations: tabs
              .map((t) => NavigationDestination(icon: t.icon, label: t.title))
              .toList(),
          selectedIndex: _currentIndex,
          onDestinationSelected: (index) {
            if (index != _currentIndex) {
              setState(() => _currentIndex = index);
              currentDelegate.update(rebuild: false);
            } else {
              currentDelegate.popToNamed(tabs[_currentIndex].path);
            }
          },
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
  });

  final String title;
  final Widget icon;
  final String path;
  final BeamLocation<RouteInformationSerializable<dynamic>> Function(
      RouteInformation info, BeamParameters? params) locationBuilder;
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
  List<String> get pathPatterns => ['/profielen/*'];
  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) => [
        const BeamPage(
          key: ValueKey('profielen'),
          child: Profielen(),
        ),
        if (state.uri.pathSegments.length == 2 &&
            state.uri.pathSegments[1] == 'import')
          BeamPage(
            key: const ValueKey('profielen/import'),
            child:
                ImportProfile(initialCode: state.uri.queryParameters['code']),
          ),
      ];
}

class TotemisatieLocation extends BeamLocation<BeamState> {
  TotemisatieLocation(super.info);
  @override
  List<String> get pathPatterns => ['/totemisatie/*'];
  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) => [
        const BeamPage(
          key: ValueKey('totemisatie'),
          child: Checklist(),
        ),
        if (state.uri.pathSegments.length >= 2 &&
            state.uri.pathSegments[1] == 'instellingen')
          const BeamPage(
            key: ValueKey('totemisatie/instellingen'),
            child: Instellingen(),
          ),
        if (state.uri.pathSegments.length == 3 &&
            state.uri.pathSegments[1] == 'instellingen' &&
            state.uri.pathSegments[2] == 'verborgen-totems')
          const BeamPage(
            key: ValueKey('totemisatie/instellingen/verborgen-totems'),
            child: VerborgenTotems(),
          ),
      ];
}
