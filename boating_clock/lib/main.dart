import 'package:flutter/material.dart';
import 'package:boating_clock/scene.dart';

class OceanTheme {
  static ThemeData buildTheme() {
    return ThemeData(
        fontFamily: 'HanaleiFill-Regular',
        textTheme: TextTheme(
          titleLarge: const TextStyle(
            fontSize: 90,
            color: Colors.white,
          ),
          titleMedium: TextStyle(
            fontSize: 65,
            color: Colors.white.withOpacity(0.75),
          ),
          titleSmall: TextStyle(
            fontSize: 40,
            color: Colors.white.withOpacity(0.5),
          ),
          // title: TextStyle(
          //   fontSize: 90,
          //   color: Colors.white,
          // ),
          // subtitle: TextStyle(
          //   fontSize: 40,
          //   color: Colors.white.withOpacity(0.5),
          // ),
        ));
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: OceanTheme.buildTheme(),
      home: Scence(),
    );
  }
}
