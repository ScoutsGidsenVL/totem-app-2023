import 'package:flutter/material.dart';
import 'package:totem_app/model/dynamic_data.dart';
import 'package:totem_app/pages/eigenschappen.dart';
import 'package:totem_app/pages/home.dart';
import 'package:provider/provider.dart';
import 'package:totem_app/pages/totems.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => DynamicData(),
        child: MaterialApp(
            title: 'Totemapp',
            theme: ThemeData(
                colorScheme: const ColorScheme.light(
                    primary: Color(0xFF004474),
                    secondary: Color(0xFF006CB9),
                    tertiary: Color(0xFF572500))),
            initialRoute: '/',
            routes: <String, WidgetBuilder>{
              '/': (context) => const Home(),
              '/totems': (context) => const Totems(),
              '/eigenschappen': (context) => const Eigenschappen(),
            }));
  }
}
