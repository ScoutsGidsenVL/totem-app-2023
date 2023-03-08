import 'package:flutter/material.dart';
import 'package:totem_app/model/dynamic_data.dart';
import 'package:totem_app/model/traits_filter.dart';
import 'package:totem_app/pages/eigenschappen.dart';
import 'package:totem_app/pages/home.dart';
import 'package:provider/provider.dart';
import 'package:totem_app/pages/totem_detail.dart';
import 'package:totem_app/pages/totems.dart';

void main() {
  runApp(const MyApp());
}

const primary = Color(0xFF005C9D);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => DynamicData()),
          ChangeNotifierProvider(create: (_) => TraitsFilter()),
        ],
        child: MaterialApp(
            title: 'Totemapp',
            theme: ThemeData(
                colorScheme: const ColorScheme.light(
                    primary: primary,
                    primaryContainer: Color(0xFF004474),
                    secondary: Color(0xFF572500)),
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
            initialRoute: '/',
            routes: <String, WidgetBuilder>{
              '/': (context) => const Home(),
              '/eigenschappen': (context) => const Eigenschappen(),
            },
            onGenerateRoute: (settings) {
              if (settings.name == '/totems') {
                final args = (settings.arguments ?? TotemsArguments())
                    as TotemsArguments;
                return MaterialPageRoute(
                    builder: (context) => Totems(filtered: args.filtered));
              } else if (settings.name == '/totem') {
                final args = settings.arguments as TotemDetailArguments;
                return MaterialPageRoute(
                    builder: (context) => TotemDetail(name: args.name));
              }
              return null;
            }));
  }
}
