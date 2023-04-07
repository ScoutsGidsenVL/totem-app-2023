import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:totemapp/model/checklist_data.dart';
import 'package:totemapp/model/dynamic_data.dart';
import 'package:totemapp/model/profile_manager.dart';
import 'package:totemapp/model/tab_manager.dart';
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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryLight = Color(0xFF005C9D);
    const primaryDark = Color(0xFF1397F5);

    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
              create: (_) => TabManager([
                    TabItem('Totems', Icons.pets, (settings) {
                      return const Totems();
                    }),
                    TabItem('Eigenschappen', Icons.psychology, (settings) {
                      if (settings.name == '/results') {
                        return const FilteredTotems();
                      }
                      return const Eigenschappen();
                    }),
                    TabItem('Profielen', Icons.person, (settings) {
                      return const Profielen();
                    }, badge: (context) {
                      final profile = context.watch<ProfileManager>().profile;
                      if (profile == null) return null;
                      final darkMode =
                          MediaQuery.of(context).platformBrightness ==
                              Brightness.dark;
                      return BadgeInfo(
                          profile.name, profile.color[darkMode ? 400 : 700]);
                    }),
                    TabItem('Checklist', Icons.check_circle, (settings) {
                      return const Checklist();
                    }),
                  ])),
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
                    surfaceVariant: Color(0xFF161616),
                    onSurfaceVariant: Color(0xFFA8B1B9)),
                textTheme: const TextTheme(
                    headlineMedium: TextStyle(
                        fontSize: 34,
                        color: primaryDark,
                        fontFamily: 'Verveine'),
                    headlineSmall: TextStyle(
                        fontSize: 17,
                        color: primaryDark,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w300),
                    bodyLarge: TextStyle(fontSize: 21),
                    bodyMedium: TextStyle(fontSize: 21),
                    bodySmall:
                        TextStyle(fontSize: 19, color: Color(0xFFA8B1B9)))),
            home: const Home()));
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final manager = context.watch<TabManager>();
    return WillPopScope(
        onWillPop: () async {
          var popped = await manager.navigatorState!.maybePop();
          if (popped) return false;
          if (manager.currentTab != 0) {
            manager.selectTab(0);
            return false;
          }
          return true;
        },
        child: Scaffold(
            body: Stack(
                children: manager.tabs
                    .mapIndexed((index, t) => Offstage(
                        offstage: manager.currentTab != index,
                        child: SafeArea(
                            child: Navigator(
                                key: manager.navigatorKeys[index],
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
              items: manager.tabs.map((t) {
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
              currentIndex: manager.currentTab,
              onTap: manager.selectTab,
              selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
            )));
  }
}
