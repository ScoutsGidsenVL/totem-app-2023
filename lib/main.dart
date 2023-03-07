import 'package:flutter/material.dart';
import 'package:totem_app/pages/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Totemapp',
        theme: ThemeData(
            colorScheme: const ColorScheme.light(
                primary: Color(0xFF005C9D),
                primaryContainer: Color(0xFF004474),
                secondary: Color(0xFF6c773b),
                tertiary: Color(0xFF572500))),
        initialRoute: '/',
        routes: <String, WidgetBuilder>{
          '/': (context) => const Home(),
        });
  }
}
